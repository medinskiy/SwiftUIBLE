import CoreBluetooth
import SwiftUIFlux

public protocol BTManager {
    func startScan()
    func stopScan()
    func connect(peripheral: BTPeripheral)
    func disconnect(peripheral: BTPeripheral)
}

public struct Manager: BTManager {
    private let cmDelegate: CBCentralManagerDelegate
    private let centralManager: CBCentralManager

    public init(delegate: CBCentralManagerDelegate) {
        self.cmDelegate = delegate
        self.centralManager = CBCentralManager(delegate: self.cmDelegate, queue: nil)
    }

    public func startScan() {
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    public func stopScan() {
        self.centralManager.stopScan()
    }

    public func connect(peripheral: BTPeripheral) {
        self.centralManager.connect(peripheral.cbPeripheral, options: nil)
    }

    public func disconnect(peripheral: BTPeripheral) {
        self.centralManager.cancelPeripheralConnection(peripheral.cbPeripheral)
    }
}
