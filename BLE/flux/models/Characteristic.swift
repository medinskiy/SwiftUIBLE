import SwiftUI
import CoreBluetooth

public protocol BTCharacteristic {
    var service: BTService { get }
    var name: String { get }
    var value: String { get }
    var isNotifing: Bool { get }
//    var properties:

    func readValue()
    func writeValue(value: String)
    func setNotify(enabled: Bool)
    func discoverDescriptors()
}

public struct Characteristic: BTCharacteristic {
    private let cbCharacteristic: CBCharacteristic
    public let service: BTService
    public var name: String {
        self.titleForUUID(self.cbCharacteristic.uuid)
    }
    public var value: String {
        String(decoding: self.cbCharacteristic.value ?? Data(), as: UTF8.self)
    }
    public var isNotifing: Bool {
        self.cbCharacteristic.properties.contains(.notify)
    }

    init(_ cbCharacteristic: CBCharacteristic, service: BTService) {
        self.cbCharacteristic = cbCharacteristic
        self.service = service
    }

    public func readValue() {
        self.service.peripheral.cbPeripheral.readValue(for: self.cbCharacteristic)
    }

    public func writeValue(value: String) {
        if let data = value.data(using: .utf8) {
            self.service.peripheral.cbPeripheral.writeValue(
                data,
                for: self.cbCharacteristic,
                type: CBCharacteristicWriteType.withResponse
            )
        }
    }
    
    public func setNotify(enabled: Bool) {
        self.service.peripheral.cbPeripheral.setNotifyValue(enabled, for: self.cbCharacteristic)
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
