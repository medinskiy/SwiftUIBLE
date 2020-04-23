import SwiftUI
import CoreBluetooth
import SwiftUIFlux

struct PeripheralView: View {
    @EnvironmentObject private var store: Store<AppState>
    let peripheralId: String
    
    var body: some View {
        let peripheral: BTPeripheral = store.state.peripherals[peripheralId]!
        
        let content = Group {
            if store.state.servicesList.isEmpty {
                Text("Load Services").padding(.top)
            } else {
                Form {
                    ForEach(store.state.servicesList, id: \.self) { serviceId in
                        ServiceRow(serviceId: serviceId)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: self.dispatchConnect(self.peripheralId))
        .onDisappear(perform: self.dispatchDisconnect(self.peripheralId))
        
        return NavigationView {
            content
                .navigationBarTitle(Text(peripheral.name), displayMode: .inline)
                .navigationBarItems(trailing: self.connectButton(self.peripheralId, peripheral.isConnected()))
        }
    }
    
    private func connectButton(_ peripheralId: String, _ isConnected: Bool) -> some View {
        let label = isConnected ? "Disonnect" : "Disonnected"
        let textLabel = Text(label).foregroundColor(isConnected ? .red : .gray)
        
        return Button(
            action: self.dispatchDisconnect(peripheralId),
            label: { textLabel.frame(height: 30) }
        ).disabled(!isConnected)
    }
    
    private func dispatchConnect(_ peripheralId: String) -> () -> Void {
        return { () -> Void in
            self.store.dispatch(action: AppAction.StopScan())
            self.store.dispatch(action: AppAction.Connect(peripheralId: peripheralId))
        }
    }
    
    private func dispatchDisconnect(_ peripheralId: String) -> () -> Void {
        return { () -> Void in
            self.store.dispatch(action: AppAction.Disconnect(peripheralId: peripheralId))
        }
    }
}

private struct ServiceRow: View {
    @EnvironmentObject private var store: Store<AppState>
    let serviceId: String
    
    var body: some View {
        let service = self.store.state.services[serviceId]
        let characteristicsList = self.store.state.characteristicsList[serviceId] ?? []
        
        return Section(header: Text(service?.name ?? "Unknown Service"), content: {
            ForEach(characteristicsList, id: \.self) { characteristicId in
                CharacteristicRow(characteristicId: characteristicId)
            }
        }).onAppear(perform: self.dispatchDiscover(self.serviceId))
    }

    private func dispatchDiscover(_ serviceId: String) -> () -> Void {
        return { () -> Void in
            self.store.dispatch(action: AppAction.DiscoverCharacteristics(serviceId: serviceId))
        }
    }
}

private struct CharacteristicRow: View {
    @EnvironmentObject private var store: Store<AppState>
    @State private var isCharacteristicPresented: Bool = false
    let characteristicId: String
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        
        return HStack {
            if characteristic == nil {
                Text("None Characteristic")
            } else {
                VStack (alignment: .leading) {
                    Text(characteristic!.name)
                    if characteristic!.value != "" {
                        Text(characteristic!.value).font(.system(size: 10))
                    }
                }.onTapGesture(perform: { self.isCharacteristicPresented.toggle() })
                Spacer()
                if characteristic!.isNotifying && characteristic!.isReading {
                    NotifyToggle(characteristicId: characteristicId).labelsHidden()
                }
            }
        }.sheet(isPresented: $isCharacteristicPresented, content: {
            CharacteristicView(characteristicId: self.characteristicId).environmentObject(self.store)
        }).onAppear(perform: self.dispatchRead(self.characteristicId))
    }

    private func dispatchRead(_ characteristicId: String) -> () -> Void {
        return { () -> Void in
            self.store.dispatch(action: AppAction.ReadValue(characteristicId: characteristicId))
        }
    }
    
    private func dispatchNotify(_ characteristicId: String, _ state: Bool) {
        self.store.dispatch(action: AppAction.SetNotify(characteristicId: characteristicId, state: state))
    }
}

