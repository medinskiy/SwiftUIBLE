import SwiftUI
import CoreBluetooth

public enum CharacteristicType: String {
    case battery = "0x180F"
    case deviceInformation = "0x180A"
    case any = "0x0"
}

public protocol BTCharacteristic {
    var service: BTService { get }
    var name: String { get }
    var valueUTF8: String { get }
    var valueInt: Int { get }
    var isNotifing: Bool { get }
    var isReaging: Bool { get }
    var isWriting: Bool { get }
    var isDetail: Bool { get }

    func readValue()
    func writeValue(value: String)
    func setNotify(enabled: Bool)
    func discoverDescriptors()
}

public class Characteristic: BTCharacteristic {
    public var service: BTService
    internal let cbCharacteristic: CBCharacteristic
    
    public var name: String { self.titleForUUID(self.cbCharacteristic.uuid) }
    public var valueUTF8: String { String(decoding: self.cbCharacteristic.value ?? Data(), as: UTF8.self) }
    public var valueInt: Int { Int(self.cbCharacteristic.value?.hexString ?? "", radix: 16) ?? 0 }
    public var isNotifing: Bool { self.cbCharacteristic.properties.contains(.notify) }
    public var isReaging: Bool { self.cbCharacteristic.properties.contains(.read) }
    public var isWriting: Bool { self.cbCharacteristic.properties.contains(.write) }
    public var isDetail: Bool { true }

    internal required init(_ cbCharacteristic: CBCharacteristic, service: BTService) {
        self.cbCharacteristic = cbCharacteristic
        self.service = service
    }
    
    public static func create(_ cbCharacteristic: CBCharacteristic, service: BTService) -> BTCharacteristic {
        if let type = CharacteristicType(rawValue: "0x\(cbCharacteristic.uuid.uuidString)") {
            switch type {
            case .battery, .deviceInformation, .any:
                return self.init(cbCharacteristic, service: service)
            }
        }
        
        return self.init(cbCharacteristic, service: service)
    }

    public func readValue() {
        if self.isReaging {
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
        if self.isNotifing {
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
