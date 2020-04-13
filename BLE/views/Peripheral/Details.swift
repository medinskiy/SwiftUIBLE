//
// Created by Ruslan on 07.04.2020.
// Copyright (c) 2020 Ruslan. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct PeripheralDetails: View {
    @EnvironmentObject private var store: Store
    let itemId: Int
    
    var body: some View {
        let item = store.state.items[itemId]!
        
        var label = Text("Connect")
        var action: Action = AppAction.Connect(item: item)
        
        if item.isConnected() {
            label = Text("Disonnect").foregroundColor(.red)
            action = AppAction.Disconnect(item: item)
        }
        
        let content = List {
            Button(
                action: { self.store.dispatch(action) },
                label: { label.frame(height: 30) }
            )
        }
        
        return NavigationView { content.navigationBarTitle(Text(item.name), displayMode: .inline) }
    }
}
