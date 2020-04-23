
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
                }
            }
        }
        
        return NavigationView {
            content
                .navigationBarItems(leading: Button(
                    action: { self.presentationMode.wrappedValue.dismiss() },
                    label: { Text("Cancel").foregroundColor(.red) }
                ))
                .navigationBarTitle(Text(characteristic!.name), displayMode: .inline)
        }
    }
}

//struct CharacteristicView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacteristicView()

//self.store.dispatch(action: AppAction.DiscoverDescriptors(characteristicId: characteristicId))
//    }
//}
