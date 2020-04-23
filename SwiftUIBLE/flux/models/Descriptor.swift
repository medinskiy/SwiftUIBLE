import SwiftUI
import CoreBluetooth

public protocol BTDescriptor {
    var characteristic: BTCharacteristic { get }
    var name: String { get }
    var value: String { get }

    func readValue()
    func writeValue(data: Data)
}

public struct Descriptor: BTDescriptor {
    private let cbDescriptor: CBDescriptor
    public let characteristic: BTCharacteristic
    public var name: String { self.cbDescriptor.uuid.description }
    public var value: String { "\(self.cbDescriptor.value ?? "")" }

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
}
