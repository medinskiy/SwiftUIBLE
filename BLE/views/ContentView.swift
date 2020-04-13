import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var store: Store

    var body: some View {
        let label = self.store.state.scanStatus ? Text("Stop").foregroundColor(.red) : Text("Start")
        let action: Action = self.store.state.scanStatus ? AppAction.StopScan() : AppAction.StartScan()
        
        let content = List {
            ForEach(self.store.state.itemsList, id: \.self) { itemId in
                NavigationLink(destination: PeripheralDetails(itemId: itemId)) {
                    self.itemRow(item: self.store.state.items[itemId]!)
                }
            }
        }.navigationBarItems(
            trailing: Button(
                action: { self.store.dispatch(action) },
                label: { label.frame(height: 30) }
            )
        )
        
        return NavigationView {
            content.navigationBarTitle("Peripheral", displayMode: .inline)
        };
    }
    
    private func itemRow(item: BTPeripheral) -> some View{
        HStack {
            Text(item.name)
            Text("\(item.rssi)dB")
        }
    }
}
