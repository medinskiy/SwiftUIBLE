import SwiftUI
import SwiftUIFlux

struct ContentView: View {
    @EnvironmentObject private var store: Store<AppState>

    var body: some View {
        let label = self.store.state.scanStatus ? Text("Stop").foregroundColor(.red) : Text("Start")
        let action: Action = self.store.state.scanStatus ? AppAction.StopScan() : AppAction.StartScan()

        let content = List {
            ForEach(self.store.state.peripheralsList, id: \.self) { itemId in
                NavigationLink(destination: PeripheralView(itemId: itemId)) {
                    self.itemRow(item: self.store.state.peripherals[itemId]!)
                }
            }
        }.navigationBarItems(
            trailing: Button(
                action: { self.store.dispatch(action: action) },
                label: { (!self.store.state.btStatus ? label.foregroundColor(.gray) : label).frame(height: 30) }
            ).disabled(!self.store.state.btStatus)
        )

        return NavigationView {
            content.navigationBarTitle("Peripheral", displayMode: .inline)
        }.onAppear(perform: {
            self.store.dispatch(action: AppAction.Init(
                btManager: Manager(delegate: CentralDelegate(dispatch: self.store.dispatch))
            ))
        });
    }

    private func itemRow(item: BTPeripheral) -> some View {
        HStack {
            Text(item.name)
            Text("\(item.rssi)dB")
        }
    }
}
