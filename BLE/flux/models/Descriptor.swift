import SwiftUI
import CoreBluetooth

public protocol BTDescriptor {
    var characteristic: BTCharacteristic { get }

    func readValue()
    func writeValue(data: Data)

    func onUpdateValue()
    func onWriteValue()
    func onFailToUpdateValue(error: Error)
    func onFailToWriteValue(error: Error)
}

class Descriptor: BTDescriptor {
    private let cbDescriptor: CBDescriptor
    let characteristic: BTCharacteristic

    init(_ cbDescriptor: CBDescriptor, characteristic: BTCharacteristic) {
        self.cbDescriptor = cbDescriptor
        self.characteristic = characteristic
    }

    public func readValue() {
        self.characteristic.service.peripheral.cbPeripheral.readValue(for: self.cbDescriptor)
    }

    public func writeValue(data: Data) {
        self.characteristic.service.peripheral.cbPeripheral.writeValue(data, for: self.cbDescriptor)
    }

    func onUpdateValue() {
    }

    func onWriteValue() {
    }

    func onFailToUpdateValue(error: Error) {
    }

    func onFailToWriteValue(error: Error) {
    }
}