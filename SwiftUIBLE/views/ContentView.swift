import SwiftUI
import SwiftUIFlux

struct ContentView: View {
    @EnvironmentObject private var store: Store<AppState>
    
    var body: some View {
        
        let content = List (self.store.state.peripheralsList, id: \.self) { itemId in
            NavigationLink(destination: PeripheralView(peripheralId: itemId)) {
                Text("\(self.store.state.peripherals[itemId]!.name) (\(self.store.state.peripherals[itemId]!.rssi)dB)")
            }
        }

        return NavigationView {
            content
                .navigationBarItems(trailing: scanButton(self.store.state.btStatus, self.store.state.scanStatus))
                .navigationBarTitle("Peripheral", displayMode: .inline)
        }.onAppear(perform: dispatchInit);
    }
    
    private func scanButton(_ btStatus: Bool, _ scanStatus: Bool) -> some View {
        let label = scanStatus ? Text("Stop").foregroundColor(.red) : Text("Start")
        let action: Action = scanStatus ? AppAction.StopScan() : AppAction.StartScan()
        
        return Button(
            action: { self.store.dispatch(action: action) },
            label: { (btStatus ? label : label.foregroundColor(.gray)).frame(height: 30) }
        ).disabled(!btStatus)
    }
    
    private func dispatchInit() {
        let action = AppAction.Init(btManager: Manager(delegate: CentralDelegate(dispatch: self.store.dispatch)))
        self.store.dispatch(action: action)
    }
}
