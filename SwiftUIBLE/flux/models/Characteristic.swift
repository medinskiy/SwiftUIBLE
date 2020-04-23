import SwiftUI
import CoreBluetooth

public protocol BTCharacteristic {
    var service: BTService { get }
    var uuid: CBUUID { get }
    var name: String { get }
    var value: String { get }
    var notificationState: Bool { get }
    var isNotifying: Bool { get }
    var isReading: Bool { get }
    var isWriting: Bool { get }

    func readValue()
    func writeValue(value: String)
    func setNotify(enabled: Bool)
    func discoverDescriptors()
}

public struct Characteristic: BTCharacteristic {
    public var service: BTService
    private let cbCharacteristic: CBCharacteristic
    private let valueParser: CharacteristicValue

    public var uuid: CBUUID { self.cbCharacteristic.uuid }
    public var name: String { self.titleForUUID(self.cbCharacteristic.uuid) }
    public var value: String { self.valueParser.parse(data: self.cbCharacteristic.value ?? Data()) }
    public var notificationState: Bool { self.cbCharacteristic.isNotifying }
    public var isNotifying: Bool { self.cbCharacteristic.properties.contains(.notify) }
    public var isReading: Bool { self.cbCharacteristic.properties.contains(.read) }
    public var isWriting: Bool { self.cbCharacteristic.properties.contains(.write) }

    init(_ cbCharacteristic: CBCharacteristic, service: BTService) {
        self.cbCharacteristic = cbCharacteristic
        self.service = service
        self.valueParser = ValueParser.getParser(
            serviceUUID: service.uuid.uuidString,
            characteristicUUID: cbCharacteristic.uuid.uuidString
        )
    }

    public func readValue() {
        if self.isReading {
            self.service.peripheral.cbPeripheral.readValue(for: self.cbCharacteristic)
        }
    }

    public func writeValue(value: String) {
        if let data = value.data(using: .utf8), self.isWriting {
            self.service.peripheral.cbPeripheral.writeValue(
                data,
                for: self.cbCharacteristic,
                type: CBCharacteristicWriteType.withResponse
            )
        }
    }

    public func setNotify(enabled: Bool) {
        if self.isNotifying {
            self.service.peripheral.cbPeripheral.setNotifyValue(enabled, for: self.cbCharacteristic)
        }
    }

    public func discoverDescriptors() {
        self.service.peripheral.cbPeripheral.discoverDescriptors(for: self.cbCharacteristic)
    }

    private func titleForUUID(_ uuid:CBUUID) -> String {
        var title = uuid.description
        if (title.hasPrefix("Unknown")) {
            title = uuid.uuidString
        }
        return title
    }
}
