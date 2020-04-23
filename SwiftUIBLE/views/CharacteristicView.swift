
import SwiftUI
import SwiftUIFlux

struct CharacteristicView: View {
    @EnvironmentObject private var store: Store<AppState>
    @Environment(\.presentationMode) var presentationMode
    let characteristicId: String
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        
        let content = HStack {
            if characteristic == nil {
                Text("Empty Characteristic")
            } else {
                Form {
                    Section(header: Text("Write"), content: {
                        Text("")
                    })
                    if characteristic!.isReading {
                        Section(header: Text("Value"), content: {
                            if characteristic!.isNotifying {
                                NotifyToggle(characteristicId: characteristicId)
                            }
                        })
                    }
                }
            }
        }
        
        return NavigationView {
            content
                .navigationBarTitle(Text(characteristic!.name), displayMode: .inline)
                .navigationBarItems(leading: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: { Text("Cancel").foregroundColor(.red) }
                ))
        }
    }
}

//struct CharacteristicView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacteristicView()

//self.store.dispatch(action: AppAction.DiscoverDescriptors(characteristicId: characteristicId))
//    }
//}


struct NotifyToggle: View {
    @EnvironmentObject private var store: Store<AppState>
    let characteristicId: String
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        
        return Toggle("Notify", isOn: Binding(
            get: { characteristic!.notificationState },
            set: { value in self.dispatchNotify(self.characteristicId, value) }
        )).disabled(!characteristic!.service.peripheral.isConnected())
    }
    
    private func dispatchNotify(_ characteristicId: String, _ state: Bool) {
        self.store.dispatch(action: AppAction.SetNotify(characteristicId: characteristicId, state: state))
    }
}
