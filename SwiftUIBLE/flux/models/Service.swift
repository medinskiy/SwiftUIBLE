import SwiftUI
import CoreBluetooth

public enum ServiceType: String {
    case battery = "0x180F"
    case deviceInformation = "0x180A"
    case any = "0x0"
}

public protocol BTService {
    var peripheral: BTPeripheral { get }
    var name: String { get }
    var type: ServiceType { get }
    var isPrimary: Bool { get }

    func discoverCharacteristics()
}

public struct Service: BTService {
    private let cbService: CBService
    public let peripheral: BTPeripheral
    public let type: ServiceType
    public var name: String { self.titleForUUID(self.cbService.uuid) }
    public var isPrimary: Bool { self.cbService.isPrimary }

    init(_ cbService: CBService, peripheral: BTPeripheral) {
        self.type = ServiceType(rawValue: "0x\(cbService.uuid.uuidString)") ?? ServiceType.any
        self.cbService = cbService
        self.peripheral = peripheral
    }

    public func discoverCharacteristics() {
        self.peripheral.cbPeripheral.discoverCharacteristics(nil, for: self.cbService)
    }
    
    private func titleForUUID(_ uuid:CBUUID) -> String {
        var title = uuid.description
        if (title.hasPrefix("Unknown")) {
            title = uuid.uuidString
        }
        return title
    }
}
