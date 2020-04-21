//
// Created by Ruslan on 07.04.2020.
// Copyright (c) 2020 Ruslan. All rights reserved.
//

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
                Text("None Services").padding(.top)
            } else {
                Form {
                    ForEach(store.state.servicesList, id: \.self) { serviceId in
                        ServiceRow(serviceId: serviceId)
                    }
                }
            }
        }.frame(maxWidth: .infinity)
        .navigationBarItems(
            trailing: connectButton(peripheral.isConnected())
        )
        
        return NavigationView {
            content.navigationBarTitle(Text(peripheral.name), displayMode: .inline)
        }.onAppear(perform: { self.dispatchConnect(self.peripheralId) })
        .onDisappear(perform: { self.dispatchDisconnect(self.peripheralId) })
    }
    
    private func connectButton(_ isConnected: Bool) -> some View {
        let label = isConnected ? "Disonnect" : "Disonnected"
        let textLabel = Text(label).foregroundColor(isConnected ? .red : .gray)
        
        return Button(
            action: { self.dispatchDisconnect(self.peripheralId) },
            label: { textLabel.frame(height: 30) }
        ).disabled(!isConnected)
    }
    
    private func dispatchConnect(_ peripheralId: String) {
        self.store.dispatch(action: AppAction.Connect(peripheralId: peripheralId))
    }
    
    private func dispatchDisconnect(_ peripheralId: String) {
        self.store.dispatch(action: AppAction.Disconnect(peripheralId: peripheralId))
    }
}

struct ServiceRow: View {
    @EnvironmentObject private var store: Store<AppState>
    let serviceId: String
    
    var body: some View {
        let service = self.store.state.services[serviceId]
        let characteristicsList = self.store.state.characteristicsList[serviceId] ?? []
        
        return Section(header: Text(service?.name ?? ""), content: {
            ForEach(characteristicsList, id: \.self) { characteristicId in
                characteristicRow(characteristicId: characteristicId)
            }
        }).onAppear(perform: { self.store.dispatch(action: AppAction.DiscoverCharacteristics(serviceId: self.serviceId)) })
    }
}

struct characteristicRow: View {
    @EnvironmentObject private var store: Store<AppState>
    @State private var isNotify: Bool = false
    @State private var isCharacteristicPresented: Bool = false
    let characteristicId: String
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        
        return HStack {
            VStack (alignment: .leading) {
                if characteristic == nil {
                    Text("None Characteristic")
                } else {
                    Text(characteristic!.name)
                    if characteristic!.valueUTF8 != "" {
                        Text(characteristic!.valueUTF8).font(.system(size: 10))
                    }
                }
            }.onTapGesture(perform: {  if characteristic?.isDetail ?? false { self.isCharacteristicPresented.toggle() } })
            Spacer()
            if characteristic != nil && characteristic!.isNotifing && characteristic!.isReaging {
                Toggle("", isOn: Binding(get: {
                    self.isNotify
                }, set: { value in
                    self.isNotify = value
                    self.store.dispatch(action: AppAction.SetNotify(characteristicId: self.characteristicId, state: value))
                })).labelsHidden()
            }
        }.onAppear(perform: { self.store.dispatch(action: AppAction.ReadValue(characteristicId: self.characteristicId)) })
        .sheet(isPresented: $isCharacteristicPresented, content: { CharacteristicView() })
    }
}
