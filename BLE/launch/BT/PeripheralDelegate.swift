import CoreBluetooth
import SwiftUIFlux

class PeripheralDelegate: NSObject, CBPeripheralDelegate {
    private let dispatch: DispatchFunction

    init(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
        super.init()
    }

    convenience override init() {
        self.init()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToDiscoverServices(error: error!))
        } else if let services = peripheral.services {
            for service in services {
                self.dispatch(PeripheralAction.OnDiscoverService(
                    peripheralId: peripheral.identifier.uuidString,
                    serviceId: service.uuid.uuidString,
                    service: service
                ))
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToDiscoverCharacteristic(
                serviceId: service.uuid.uuidString,
                error: error!
            ))
        } else if let characteristics = service.characteristics {
            for characteristic in characteristics {
                self.dispatch(PeripheralAction.OnDiscoverCharacteristic(
                    serviceId: service.uuid.uuidString,
                    characteristicId: characteristic.uuid.uuidString,
                    characteristic: characteristic
                ))
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToUpdateCharacteristicValue(
                characteristicId: characteristic.uuid.uuidString,
                error: error!
            ))
        } else {
            self.dispatch(PeripheralAction.OnUpdateCharacteristicValue(
                characteristicId: characteristic.uuid.uuidString
            ))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToWriteCharacteristicValue(
                characteristicId: characteristic.uuid.uuidString,
                error: error!
            ))
        } else {
            self.dispatch(PeripheralAction.OnWriteCharacteristicValue(
                characteristicId: characteristic.uuid.uuidString
            ))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToDiscoverDescriptors(
                characteristicId: characteristic.uuid.uuidString,
                error: error!
            ))
        } else if let descriptors = characteristic.descriptors {
            for descriptor in descriptors {
                self.dispatch(PeripheralAction.onDiscoverDescriptor(
                    characteristicId: characteristic.uuid.uuidString,
                    descriptorId: descriptor.uuid.uuidString,
                    descriptor: descriptor
                ))
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToUpdateDescriptorValue(
                descriptorId: descriptor.uuid.uuidString,
                error: error!
            ))
        } else {
            self.dispatch(PeripheralAction.OnUpdateDescriptorValue(descriptorId: descriptor.uuid.uuidString))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if error != nil {
            self.dispatch(PeripheralAction.OnFailToWriteDescriptorValue(
                descriptorId: descriptor.uuid.uuidString,
                error: error!
            ))
        } else {
            self.dispatch(PeripheralAction.OnWriteDescriptorValue(descriptorId: descriptor.uuid.uuidString))
        }
    }
}
