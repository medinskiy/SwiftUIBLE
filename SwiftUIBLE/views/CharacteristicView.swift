
import SwiftUI
import SwiftUIFlux

struct CharacteristicView: View {
    @EnvironmentObject private var store: Store<AppState>
    @Environment(\.presentationMode) var presentationMode
    
    let characteristicId: String
    @State private var writeValue = ""
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        let descriptorsList = self.store.state.descriptorsList[characteristicId] ?? []
        let values = self.store.state.values[characteristicId] ?? []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSSS"
        
        let content = HStack {
            if characteristic == nil {
                Text("Empty Characteristic")
            } else {
                Form {
                    if characteristic!.isWriting {
                        Section(header: Text("Write"), content: {
                            HStack{
                                TextField("Enter value", text: $writeValue).labelsHidden()
                                Button("Send") {
                                    self.dispatchWrite(self.characteristicId, self.writeValue)
                                    self.writeValue = ""
                                }.disabled(!characteristic!.service.peripheral.isConnected())
                            }
                        })
                    }
                    if characteristic!.isReading {
                        Section(header: Text("Values"), content: {
                            HStack {
                                Button("Read value") {
                                    self.dispatchRead(self.characteristicId)
                                }.disabled(!characteristic!.service.peripheral.isConnected())
                                Spacer()
                                if characteristic!.isNotifying {
                                    NotifyToggle(characteristicId: characteristicId).labelsHidden()
                                }
                            }
                            ForEach(values, id: \.0) { value in
                                VStack(alignment: .leading) {
                                    Text(value.1)
                                    Text(dateFormatter.string(from: value.0)).font(.system(size: 10))
                                }
                            }
                        })
                    }
                    Section(header: Text("Properties"), content: {
                        if characteristic!.isReading {
                            Text("Reading")
                        }
                        if characteristic!.isWriting {
                            Text("Writing")
                        }
                        if characteristic!.isNotifying {
                            Text("Notifying")
                        }
                    })
                    Section(header: Text("Descriptors"), content: {
                        if descriptorsList.isEmpty {
                            Text("Empty List")
                        } else {
                            ForEach(descriptorsList, id: \.self) { descriptorId in
                                DescriptorRow(descriptorId: descriptorId)
                            }
                        }
                    })
                }
            }
        }.onAppear(perform: self.dispatchDiscover(self.characteristicId))
        
        return NavigationView {
            content
                .navigationBarTitle(Text(characteristic!.name), displayMode: .inline)
                .navigationBarItems(leading: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: { Text("Cancel").foregroundColor(.red) }
                ))
        }
    }
    
    private func dispatchDiscover(_ characteristicId: String) -> () -> Void {
        return { () -> Void in
            self.store.dispatch(action: AppAction.DiscoverDescriptors(characteristicId: characteristicId))
        }
    }
    
    private func dispatchRead(_ characteristicId: String) {
        self.store.dispatch(action: AppAction.ReadValue(characteristicId: characteristicId))
    }
    
    private func dispatchWrite(_ characteristicId: String, _ value: String) {
        self.store.dispatch(action: AppAction.WriteValue(characteristicId: characteristicId, value: value))
    }
}

struct NotifyToggle: View {
    @EnvironmentObject private var store: Store<AppState>
    let characteristicId: String
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        
        return Toggle("Notify", isOn: Binding(
            get: { characteristic?.notificationState ?? false },
            set: { value in self.dispatchNotify(self.characteristicId, value) }
        )).disabled(!(characteristic?.service.peripheral.isConnected() ?? false))
    }
    
    private func dispatchNotify(_ characteristicId: String, _ state: Bool) {
        self.store.dispatch(action: AppAction.SetNotify(characteristicId: characteristicId, state: state))
    }
}

private struct DescriptorRow: View {
    @EnvironmentObject private var store: Store<AppState>
    let descriptorId: String
    
    var body: some View {
        let descriptor = self.store.state.descriptors[descriptorId]
        
        return HStack {
                if descriptor == nil {
                    Text("None descriptor")
                } else {
                    VStack (alignment: .leading) {
                        Text(descriptor!.name)
                        if descriptor!.value != "" {
                            Text(descriptor!.value).font(.system(size: 10))
                        }
                    }
                }
            }.onAppear(perform: self.dispatchRead(self.descriptorId))
        }

        private func dispatchRead(_ descriptorId: String) -> () -> Void {
            return { () -> Void in
                self.store.dispatch(action: AppAction.ReadDescriptorValue(descriptorId: descriptorId))
            }
        }
}
