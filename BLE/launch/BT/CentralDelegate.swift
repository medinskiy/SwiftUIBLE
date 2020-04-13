
import CoreBluetooth

public class CentralDelegate: NSObject, CBCentralManagerDelegate
{
    private let logger: Logger?
    private let manager: Manager

    init(manager: Manager, logger: Logger?) {
        self.manager = manager
        self.logger = logger
        super.init()
    }

    convenience override init() {
        self.init()
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        logger?.debug("centralManagerDidUpdateState \(central.state.rawValue)")
        self.manager.onUpdateState(state: central.state)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        self.manager.onDiscover(peripheral: peripheral, rssi: RSSI)
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let item = self.manager.getPeripheral(id: peripheral.hash) {
            self.logger?.debug("Connect to peripheral \(peripheral.hash)")
            item.onConnect()
        }
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let item = self.manager.getPeripheral(id: peripheral.hash) {
            self.logger?.debug("Fail connect to peripheral \(peripheral.hash)")
            item.onFailToConnect(error: error)
        }
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let item = self.manager.getPeripheral(id: peripheral.hash) {
            self.logger?.debug("Disconnect from peripheral \(peripheral.hash)")
            item.onDisconnect(error: error)
        }
    }
}
