import SwiftUI
import CoreBluetooth

public protocol BTService {
    var peripheral: BTPeripheral { get }
    var uuid: CBUUID { get }
    var name: String { get }
    var isPrimary: Bool { get }

    func discoverCharacteristics()
}

public struct Service: BTService {
    private let cbService: CBService
    public let peripheral: BTPeripheral
    public var uuid: CBUUID { self.cbService.uuid }
    public var name: String { self.titleForUUID(self.cbService.uuid) }
    public var isPrimary: Bool { self.cbService.isPrimary }

    init(_ cbService: CBService, peripheral: BTPeripheral) {
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
