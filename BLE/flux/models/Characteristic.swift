import SwiftUI
import CoreBluetooth

public protocol BTCharacteristic {
    var service: BTService { get }

    func readValue()
    func writeValue(data: Data)
    func setNotify(enabled: Bool)
    func getDescriptor(id: Int) -> BTDescriptor?
    func discoverDescriptors()

    func onDiscoverDescriptor(descriptor: CBDescriptor)
    func onUpdateValue()
    func onWriteValue()
    func onFailToUpdateValue(error: Error)
    func onFailToWriteValue(error: Error)
    func onFailToDiscoverDescriptors(error: Error)
}

class Characteristic: BTCharacteristic {
    private let cbCharacteristic: CBCharacteristic
    let service: BTService

    private var descriptors: [Int: Descriptor] = [:]

    init(_ cbCharacteristic: CBCharacteristic, service: BTService) {
        self.cbCharacteristic = cbCharacteristic
        self.service = service
    }

    public func readValue() {
        self.service.peripheral.cbPeripheral.readValue(for: self.cbCharacteristic)
    }

    public func writeValue(data: Data) {
        self.service.peripheral.cbPeripheral.writeValue(
            data,
            for: self.cbCharacteristic,
            type: CBCharacteristicWriteType.withResponse
        )
    }

    public func setNotify(enabled: Bool) {
        self.service.peripheral.cbPeripheral.setNotifyValue(enabled, for: self.cbCharacteristic)
    }

    public func getDescriptor(id: Int) -> BTDescriptor? {
        return self.descriptors[id]
    }

    public func discoverDescriptors() {
        self.service.peripheral.cbPeripheral.discoverDescriptors(for: self.cbCharacteristic)
    }

    func onDiscoverDescriptor(descriptor: CBDescriptor) {
        if self.descriptors.keys.contains(descriptor.hash) == false {
            self.descriptors[descriptor.hash] = Descriptor(descriptor, characteristic: self)
        }
    }

    func onUpdateValue() {
    }

    func onWriteValue() {
    }

    func onFailToUpdateValue(error: Error) {
    }

    func onFailToWriteValue(error: Error) {
    }

    func onFailToDiscoverDescriptors(error: Error) {
    }
}