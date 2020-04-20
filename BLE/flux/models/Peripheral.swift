import SwiftUI
import CoreBluetooth

public protocol BTPeripheral {
    var cbPeripheral: CBPeripheral { get }
    var rssi: NSNumber { get }
    var name: String { get }

    func isConnected() -> Bool
    func discoverServices()
}

public struct Peripheral: BTPeripheral {
    let delegate: CBPeripheralDelegate
    public let cbPeripheral: CBPeripheral
    public var rssi: NSNumber
    public var name: String {
        self.cbPeripheral.name ?? "NoName"
    }

    init(_ cbPeripheral: CBPeripheral, rssi: NSNumber, delegate: CBPeripheralDelegate) {
        self.cbPeripheral = cbPeripheral
        self.rssi = rssi
        self.delegate = delegate
        self.cbPeripheral.delegate = self.delegate
    }

    public func isConnected() -> Bool {
        self.cbPeripheral.state == CBPeripheralState.connected
    }

    public func discoverServices() {
        self.cbPeripheral.discoverServices(nil)
    }
}
