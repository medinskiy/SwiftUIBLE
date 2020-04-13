import CoreBluetooth

class PeripheralDelegate: NSObject, CBPeripheralDelegate {
    private let logger: Logger?
    private let peripheral: BTPeripheral

    init(peripheral: BTPeripheral, logger: Logger?) {
        self.peripheral = peripheral
        self.logger = logger
        super.init()
    }

    convenience override init() {
        self.init()
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            self.peripheral.onFailToDiscoverServices(error: error)
        } else if let services = peripheral.services {
            for service in services {
                self.peripheral.onDiscoverService(service: service)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let item = self.peripheral.getService(id: service.hash) {
            if error != nil {
                item.onFailToDiscoverCharacteristic(error: error!)
            } else if let characteristics = service.characteristics {
                for characteristic in characteristics {
                    item.onDiscoverCharacteristic(characteristic: characteristic)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let item = self.peripheral
            .getService(id: characteristic.service.hash)?
            .getCharacteristic(id: characteristic.hash)
        {
            if error != nil {
                item.onFailToUpdateValue(error: error!)
            } else {
                item.onUpdateValue()
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let item = self.peripheral
            .getService(id: characteristic.service.hash)?
            .getCharacteristic(id: characteristic.hash)
        {
            if error != nil {
                item.onFailToWriteValue(error: error!)
            } else {
                item.onWriteValue()
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        if let item = self.peripheral
            .getService(id: characteristic.service.hash)?
            .getCharacteristic(id: characteristic.hash)
        {
            if error != nil {
                item.onFailToDiscoverDescriptors(error: error!)
            } else if let descriptors = characteristic.descriptors {
                for descriptor in descriptors {
                    item.onDiscoverDescriptor(descriptor: descriptor)
                }
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if let item = self.peripheral
            .getService(id: descriptor.characteristic.service.hash)?
            .getCharacteristic(id: descriptor.characteristic.hash)?
            .getDescriptor(id: descriptor.hash)
        {
            if error != nil {
                item.onFailToUpdateValue(error: error!)
            } else {
                item.onUpdateValue()
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if let item = self.peripheral
            .getService(id: descriptor.characteristic.service.hash)?
            .getCharacteristic(id: descriptor.characteristic.hash)?
            .getDescriptor(id: descriptor.hash)
        {
            if error != nil {
                item.onFailToWriteValue(error: error!)
            } else {
                item.onWriteValue()
            }
        }
    }
}