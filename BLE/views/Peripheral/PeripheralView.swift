//
// Created by Ruslan on 07.04.2020.
// Copyright (c) 2020 Ruslan. All rights reserved.
//

import SwiftUI
import CoreBluetooth
import SwiftUIFlux

struct PeripheralView: View {
    @EnvironmentObject private var store: Store<AppState>
    let itemId: String
    
    var body: some View {
        let peripheral: BTPeripheral = store.state.peripherals[itemId]!
        
        let label = peripheral.isConnected() ? "Disonnect" : "Disonnected"
        
        let content = ScrollView {
            VStack {
                if store.state.servicesList.isEmpty {
                    Text("Empty list").padding(.top)
                } else {
                    ForEach(store.state.servicesList, id: \.self) { serviceId in
                        ServiceRow(serviceId: serviceId)
                    }
                }
            }.frame(maxWidth: .infinity)
        }.navigationBarItems(
            trailing: Button(
                action: { self.store.dispatch(action: AppAction.Disconnect(peripheralId: self.itemId)) },
                label: { Text(label).foregroundColor(.red).frame(height: 30) }
            ).disabled(!peripheral.isConnected())
        )
        
        return NavigationView {
            content.navigationBarTitle(Text(peripheral.name), displayMode: .inline)
        }
        .onAppear(perform: { self.store.dispatch(action: AppAction.Connect(peripheralId: self.itemId)) })
        .onDisappear(perform: { self.store.dispatch(action: AppAction.Disconnect(peripheralId: self.itemId)) })
    }
}

struct ServiceRow: View {
    @EnvironmentObject private var store: Store<AppState>
    let serviceId: String
    
    var body: some View {
        let service = self.store.state.services[serviceId]
        let characteristicsList = self.store.state.characteristicsList[serviceId] ?? []
        
        return VStack {
            HStack {
                Text(service?.name ?? "").font(.headline).foregroundColor(.black)
                Spacer()
            }.padding().background(Color.white)
            .onTapGesture(perform: {
                if characteristicsList.isEmpty {
                    self.store.dispatch(action: AppAction.DiscoverCharacteristics(serviceId: self.serviceId))
                }
            })
            ForEach(characteristicsList, id: \.self) { characteristicId in
                characteristicRow(characteristicId: characteristicId)
            }
        }.padding(.top)
    }
}

struct characteristicRow: View {
    @EnvironmentObject private var store: Store<AppState>
    @State private var isNotify: Bool = false
    let characteristicId: String
    
    var body: some View {
        let characteristic = self.store.state.characteristics[characteristicId]
        
        return HStack {
            VStack (alignment: .leading) {
                Text(characteristic?.name ?? "")
                Text(characteristic?.value ?? "").font(.system(size: 10))
            }.onTapGesture(count: 1, perform: {
                self.store.dispatch(action: AppAction.ReadValue(characteristicId: self.characteristicId))
            }).gesture(LongPressGesture().onEnded { _ in
                self.store.dispatch(action: AppAction.WriteValue(characteristicId: self.characteristicId, value: "test"))
            })
            Spacer()
            if characteristic?.isNotifing ?? false {
                Toggle("", isOn: Binding(get: {
                    self.isNotify
                }, set: { value in
                    self.isNotify = value
                    self.store.dispatch(action: AppAction.SetNotify(characteristicId: self.characteristicId, state: value))
                })).labelsHidden()
            }
        }.padding().background(Color.gray)
    }
}



/*
 
"5C1193F3-A095-1C40-7B87-A6789C5DAE1C": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280f453a0>, cbPeripheral: <CBPeripheral: 0x283e6d0e0, identifier = 5C1193F3-A095-1C40-7B87-A6789C5DAE1C, name = iPad, state = connected>, rssi: -38)
 services: [
    "180F": BLE.Service(cbService: <CBService: 0x281ab4440, isPrimary = YES, UUID = Battery>)
 ],
 characteristics: [
 "2A19": BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x282b5e0a0, UUID = Battery Level, properties = 0x12, value = {length = 1, bytes = 0x23}, notifying = NO>),
 ],
 characteristicsList: ["180F": ["2A19"]],
 
 
BLE.AppState(
    manager: Optional(BLE.Manager(
        cmDelegate: <BLE.CentralDelegate: 0x2807a5f60>,
        centralManager: <CBCentralManager: 0x282ca75d0>)
    ),
    btStatus: true,
    scanStatus: false,
    peripherals: [
        "34CC2CB5-4064-6B5D-04A4-2B69F9F2FB98": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807b9de0>, cbPeripheral: <CBPeripheral: 0x2836bada0, identifier = 34CC2CB5-4064-6B5D-04A4-2B69F9F2FB98, name = [TV] Samsung 6 Series (40), state = disconnected>, rssi: -78),
        "967FE944-691E-149C-1C9B-B281E4A515E3": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807984a0>, cbPeripheral: <CBPeripheral: 0x2836bc000, identifier = 967FE944-691E-149C-1C9B-B281E4A515E3, name = (null), state = disconnected>,rssi: -95),
        "5C1193F3-A095-1C40-7B87-A6789C5DAE1C": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280785700>, cbPeripheral: <CBPeripheral: 0x2836bb020, identifier = 5C1193F3-A095-1C40-7B87-A6789C5DAE1C, name = iPad, state = disconnected>, rssi: -59),
        "B484B361-F13B-963A-2430-982D549C7FE4": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807b9700>, cbPeripheral: <CBPeripheral: 0x2836b0320, identifier = B484B361-F13B-963A-2430-982D549C7FE4, name = [TV] Samsung 6 Series (55), state = disconnected>, rssi: -98),
        "693066FF-E4EA-C727-C399-D02B4DE5C956": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807be3a0>, cbPeripheral: <CBPeripheral: 0x2836ac280, identifier = 693066FF-E4EA-C727-C399-D02B4DE5C956, name = (null), state = disconnected>, rssi: -97),
        "01189BCB-69BB-C69E-BC90-3A284FDE6B80": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807846c0>, cbPeripheral: <CBPeripheral: 0x2836baee0, identifier = 01189BCB-69BB-C69E-BC90-3A284FDE6B80, name = (null), state = disconnected>, rssi: -90),
        "C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39),
        "C52100CA-64C8-A97C-DE11-2544588C9E9A": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807fc520>, cbPeripheral: <CBPeripheral: 0x2836b4460, identifier = C52100CA-64C8-A97C-DE11-2544588C9E9A, name = MacBook Pro 13', state = disconnected>, rssi: -31),
        "1B0A5C88-1ECB-165C-0A15-1F6F2B6A041B": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280785560>, cbPeripheral: <CBPeripheral: 0x2836bc8c0, identifier = 1B0A5C88-1ECB-165C-0A15-1F6F2B6A041B, name = [TV] Samsung Q6 Series (49), state = disconnected>, rssi: -91),
        "9C841F0E-4CB9-EEE8-2C2D-5FB544C1B756": BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807b8d60>, cbPeripheral: <CBPeripheral: 0x2836b0000, identifier = 9C841F0E-4CB9-EEE8-2C2D-5FB544C1B756, name = (null), state = disconnected>, rssi: -64)
    ],
    peripheralsList: ["C52100CA-64C8-A97C-DE11-2544588C9E9A", "01189BCB-69BB-C69E-BC90-3A284FDE6B80", "34CC2CB5-4064-6B5D-04A4-2B69F9F2FB98", "5C1193F3-A095-1C40-7B87-A6789C5DAE1C", "C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE", "967FE944-691E-149C-1C9B-B281E4A515E3", "1B0A5C88-1ECB-165C-0A15-1F6F2B6A041B", "9C841F0E-4CB9-EEE8-2C2D-5FB544C1B756", "B484B361-F13B-963A-2430-982D549C7FE4", "693066FF-E4EA-C727-C399-D02B4DE5C956"],
    services: [
        "9FA480E0-4967-4542-9390-D343DC5D04AE": BLE.Service(cbService: <CBService: 0x281274c80, isPrimary = YES, UUID = 9FA480E0-4967-4542-9390-D343DC5D04AE>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807fc520>, cbPeripheral: <CBPeripheral: 0x2836b4460, identifier = C52100CA-64C8-A97C-DE11-2544588C9E9A, name = MacBook Pro 13, state = disconnected>, rssi: -31)),
        "180A": BLE.Service(cbService: <CBService: 0x281274000, isPrimary = YES, UUID = Device Information>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807fc520>, cbPeripheral: <CBPeripheral: 0x2836b4460, identifier = C52100CA-64C8-A97C-DE11-2544588C9E9A, name = MacBook Pro 13', state = disconnected>, rssi: -31)),
        "D0611E78-BBB4-4591-A5F8-487910AE4366": BLE.Service(cbService: <CBService: 0x281274780, isPrimary = YES, UUID = Continuity>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x2807fc520>, cbPeripheral: <CBPeripheral: 0x2836b4460, identifier = C52100CA-64C8-A97C-DE11-2544588C9E9A, name = MacBook Pro 13', state = disconnected>, rssi: -31))
    ],
    servicesList: [
            "C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE": ["D0611E78-BBB4-4591-A5F8-487910AE4366", "9FA480E0-4967-4542-9390-D343DC5D04AE", "180A"]
    ],
    characteristics: [
        "2A29": BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x2823af300, UUID = Manufacturer Name String, properties = 0x2, value = {length = 10, bytes = 0x4170706c6520496e632e}, notifying = NO>, service: BLE.Service(cbService: <CBService: 0x281265680, isPrimary = YES, UUID = Device Information>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39))),
        "8667556C-9A37-4C91-84ED-54EE27D90049": BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x2823afcc0, UUID = Continuity, properties = 0x98, value = (null), notifying = NO>, service: BLE.Service(cbService: <CBService: 0x281265740, isPrimary = YES, UUID = Continuity>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39))),
        "2A24": BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x2823af9c0, UUID = Model Number String, properties = 0x2, value = {length = 8, bytes = 0x5761746368332c34}, notifying = NO>, service: BLE.Service(cbService: <CBService: 0x281265680, isPrimary = YES, UUID = Device Information>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39))),
        "AF0BADB1-5B99-43CD-917A-A77BC549E3CC": BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x2823ae220, UUID = AF0BADB1-5B99-43CD-917A-A77BC549E3CC, properties = 0x98, value = (null), notifying = NO>, service: BLE.Service(cbService: <CBService: 0x281265c40, isPrimary = YES, UUID = 9FA480E0-4967-4542-9390-D343DC5D04AE>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39)))
    ],
    characteristicsList: [
        "D0611E78-BBB4-4591-A5F8-487910AE4366": ["8667556C-9A37-4C91-84ED-54EE27D90049"],
        "180A": ["2A29", "2A24"],
        "9FA480E0-4967-4542-9390-D343DC5D04AE": ["AF0BADB1-5B99-43CD-917A-A77BC549E3CC"]
    ],
    descriptors: [
        "2900": BLE.Descriptor(cbDescriptor: <CBDescriptor: 0x2809200c0, UUID = Characteristic Extended Properties, value = 1>, characteristic: BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x2823ae220, UUID = AF0BADB1-5B99-43CD-917A-A77BC549E3CC, properties = 0x98, value = (null), notifying = NO>, service: BLE.Service(cbService: <CBService: 0x281265c40, isPrimary = YES, UUID = 9FA480E0-4967-4542-9390-D343DC5D04AE>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39)))),
        "2902": BLE.Descriptor(cbDescriptor: <CBDescriptor: 0x280923ea0, UUID = Client Characteristic Configuration, value = 0>, characteristic: BLE.Characteristic(cbCharacteristic: <CBCharacteristic: 0x2823ae220, UUID = AF0BADB1-5B99-43CD-917A-A77BC549E3CC, properties = 0x98, value = (null), notifying = NO>, service: BLE.Service(cbService: <CBService: 0x281265c40, isPrimary = YES, UUID = 9FA480E0-4967-4542-9390-D343DC5D04AE>, peripheral: BLE.Peripheral(delegate: <BLE.PeripheralDelegate: 0x280790840>, cbPeripheral: <CBPeripheral: 0x2836bc500, identifier = C6A6AA20-EF90-7BFE-8548-E2B5A28C32DE, name = Ruslan Apple Watch, state = disconnected>, rssi: -39))))
    ],
    descriptorsList: ["8667556C-9A37-4C91-84ED-54EE27D90049": ["2900", "2902"]]
)
*/
