import SwiftUI
import CoreBluetooth

public protocol BTPeripheral {
    var cbPeripheral: CBPeripheral { get }
    var rssi: NSNumber { get }
    var name: String { get }

    func setDelegate(delegate: CBPeripheralDelegate)
    func updateRssi(rssi: NSNumber)
    func getService(id: Int) -> BTService?
    func discoverServices()

    func isConnected() -> Bool
    func onConnect()
    func onDisconnect(error: Error?)
    func onFailToConnect(error: Error?)
    func onDiscoverService(service: CBService)
    func onFailToDiscoverServices(error: Error?)
}

class Peripheral: BTPeripheral {
    let cbPeripheral: CBPeripheral
    var rssi: NSNumber
    var name: String { self.cbPeripheral.name ?? "NoName" }
    

    private var services: [Int: Service] = [:]

    init(_ cbPeripheral: CBPeripheral, rssi: NSNumber) {
        self.cbPeripheral = cbPeripheral
        self.rssi = rssi
    }

    public func setDelegate(delegate: CBPeripheralDelegate) {
        self.cbPeripheral.delegate = delegate
    }

    public func updateRssi(rssi: NSNumber) {
        self.rssi = rssi
    }

    public func getService(id: Int) -> BTService? {
        return self.services[id]
    }

    public func isConnected() -> Bool {
        self.cbPeripheral.state == CBPeripheralState.connected
    }

    public func discoverServices() {
        self.cbPeripheral.discoverServices(nil)
    }

    func onConnect() {
    }

    func onDisconnect(error: Error?) {
    }

    func onFailToConnect(error: Error?) {
    }

    func onDiscoverService(service: CBService) {
        if self.services.keys.contains(service.hash) == false {
            self.services[service.hash] = Service(service, peripheral: self)
        }
    }

    func onFailToDiscoverServices(error: Error?) {
    }
}
