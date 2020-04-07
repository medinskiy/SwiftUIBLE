//
//  ContentView.swift
//  BLE
//
//  Created by Ruslan on 22.03.2020.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var store: Store
    @State private var showingDetail = false

    var body: some View {
        let content = List {
            ForEach (self.store.state.items) { item in
                NavigationLink (destination: PeripheralView(item: item)) {
                    HStack {
                        Text(item.name)
                        Text("\(item.rssi.stringValue)dB")
                    }.onTapGesture {
                        print(item.name)
                    }
                }
            }
        }
        .sheet(isPresented: self.$showingDetail, content: { SheetView().environmentObject(self.store) })
        .navigationBarItems(
            leading: Button(
                action: { self.store.dispatch(action: AppAction.StopScan()); self.showingDetail = true },
                label: { Text("Stop").frame(height: 30).foregroundColor(.red) }
            ),
            trailing: Button(
                action: { self.store.dispatch(action: AppAction.StartScan()); },
                label: { Text("Scan").frame(height: 30) }
            )
        ).navigationBarTitle("Peripheral")

        return NavigationView { content };
    }
}

struct SheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var store: Store

    var body: some View {
        NavigationView {
            Text(String(store.state.items.count))
            .navigationBarItems(
                leading: Button (
                    action: hide,
                    label: { Text("Cancel").foregroundColor(.red) }
                )
            )
        }
    }

    func hide() {
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct PeripheralView: View {
    var item: Item

    var body: some View {
        NavigationView {
            VStack {
                Text(self.item.name).font(.title)
                Text(self.item.rssi.stringValue).font(.subheadline)
                Divider()
            }.navigationBarTitle(Text("Details"))
        }
    }
}
