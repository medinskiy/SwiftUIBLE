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
                .navigationBarTitle("Peripheral", displayMode: .inline)
                .navigationBarItems(trailing: self.scanButton(self.store.state.btStatus, self.store.state.scanStatus))
        }.onAppear(perform: dispatchInit);
    }
    
    private func scanButton(_ btStatus: Bool, _ scanStatus: Bool) -> some View {
        let label = scanStatus ? Text("Stop").foregroundColor(.red) : Text("Start")
        let action = scanStatus ? self.dispatchStopScan : self.dispatchStartScan
        
        return Button(
            action: action,
            label: { (btStatus ? label : label.foregroundColor(.gray)).frame(height: 30) }
        ).disabled(!btStatus)
    }
    
    private func dispatchInit() {
        let action = AppAction.Init(btManager: Manager(delegate: CentralDelegate(dispatch: self.store.dispatch)))
        self.store.dispatch(action: action)
    }
    
    private func dispatchStartScan() {
        let action = AppAction.StartScan(
            stopTimer: Timer(timeInterval: 5.0, repeats: false, block: { _ in self.dispatchStopScan() })
        )
        self.store.dispatch(action: action)
    }
    
    private func dispatchStopScan() {
        self.store.dispatch(action: AppAction.StopScan())
    }
}
