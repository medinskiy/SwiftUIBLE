import CoreBluetooth
import SwiftUIFlux
import CoreBluetooth

extension Data {
    var hexString: String {
        var hex:String = ""
        for byte in self {
            hex += String(format: "%02X", byte)
        }
        return hex
    }
}

func appStateReducer(state: AppState, action: Action) -> AppState {
    var state = state
    
    switch action {
        
    case let action as AppAction.Init:
        state.manager = action.btManager

    case _ as AppAction.StartScan:
        state.scanStatus = true
        state.manager?.startScan()

    case _ as AppAction.StopScan:
        state.scanStatus = false
        state.manager?.stopScan()

    case let action as AppAction.Connect:
        state = state.cleared()
        if let item = state.peripherals[action.peripheralId] {
            state.manager?.connect(peripheral: item)
        }

    case let action as AppAction.Disconnect:
        if let item = state.peripherals[action.peripheralId] {
            state.manager?.disconnect(peripheral: item)
        }

    case let action as AppAction.DiscoverCharacteristics:
        if let service = state.services[action.serviceId] {
            service.discoverCharacteristics()
        }
        
    case let action as AppAction.DiscoverDescriptors:
        if let characteristic = state.characteristics[action.characteristicId] {
            characteristic.discoverDescriptors()
        }
        
    case let action as AppAction.WriteValue:
        if let characteristic = state.characteristics[action.characteristicId] {
            characteristic.writeValue(value: action.value)
        }
        
    case let action as AppAction.ReadValue:
        if let characteristic = state.characteristics[action.characteristicId] {
            characteristic.readValue()
        }
        
    case let action as AppAction.SetNotify:
        if let characteristic = state.characteristics[action.characteristicId] {
            characteristic.setNotify(enabled: action.state)
        }
        

    case let action as CentralAction.OnUpdateState:
        state.btStatus = action.state == CBManagerState.poweredOn

    case let action as CentralAction.OnConnectPeripheral:
        if let peripheral = state.peripherals[action.peripheralId] {
            peripheral.discoverServices()
        }

    case let action as CentralAction.OnDiscoverPeripheral:
        if state.peripherals[action.peripheralId] == nil {
            state.peripheralsList.append(action.peripheralId)
        }
        state.peripherals[action.peripheralId] = Peripheral(action.peripheral, rssi: action.rssi, delegate: action.delegate)


    case let action as PeripheralAction.OnDiscoverService:
        if let peripheral = state.peripherals[action.peripheralId] {
            if state.services[action.serviceId] == nil {
                state.servicesList.append(action.serviceId)
            }
            state.services[action.serviceId] = Service(action.service, peripheral: peripheral)
        }

    case let action as PeripheralAction.OnDiscoverCharacteristic:
        if let service = state.services[action.serviceId] {
            if state.characteristics[action.characteristicId] == nil {
                if state.characteristicsList[action.serviceId] == nil {
                    state.characteristicsList[action.serviceId] = []
                }
                state.characteristicsList[action.serviceId]!.append(action.characteristicId)
            }
            state.characteristics[action.characteristicId] = Characteristic.create(action.characteristic, service: service)
        }

    case let action as PeripheralAction.onDiscoverDescriptor:
        if let characteristic = state.characteristics[action.characteristicId] {
            if state.descriptors[action.descriptorId] == nil {
                if state.descriptorsList[action.characteristicId] == nil {
                    state.descriptorsList[action.characteristicId] = []
                }
                state.descriptorsList[action.characteristicId]!.append(action.descriptorId)
            }
            state.descriptors[action.descriptorId] = Descriptor(action.descriptor, characteristic: characteristic)
        }

    case let action as PeripheralAction.OnUpdateCharacteristicValue:
        if let characteristic = state.characteristics[action.characteristicId] {
            print("##OnUpdateCharacteristicValue \(characteristic.name) \(characteristic.valueUTF8) \(characteristic.valueInt)")
        }
        
    case let action as PeripheralAction.OnWriteCharacteristicValue:
        if let characteristic = state.characteristics[action.characteristicId] {
            print("##OnWriteCharacteristicValue \(characteristic.name) \(characteristic.valueUTF8)  \(characteristic.valueInt)")
        }
        
    case let action as PeripheralAction.OnFailToDiscoverServices:
        print("FailToDiscoverServices: \(action.error)")
    case let action as PeripheralAction.OnFailToDiscoverCharacteristic:
        print("FailToDiscoverCharacteristic: \(action.error)")
    case let action as PeripheralAction.OnFailToDiscoverDescriptors:
        print("FailToDiscoverDescriptors: \(action.error)")
    case let action as PeripheralAction.OnFailToUpdateCharacteristicValue:
        print("FailToUpdateCharacteristicValue: \(action.error)")
        
    default:
        break;
    }
    
    return state;
}
