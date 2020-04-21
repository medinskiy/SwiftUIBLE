import CoreBluetooth
import SwiftUIFlux

public class CentralDelegate: NSObject, CBCentralManagerDelegate {
    private let dispatch: DispatchFunction

    init(dispatch: @escaping DispatchFunction) {
        self.dispatch = dispatch
        super.init()
    }

    convenience override init() {
        self.init()
    }

    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.dispatch(CentralAction.OnUpdateState(state: central.state))
        if central.state != .poweredOn {
            self.dispatch(AppAction.StopScan())
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        self.dispatch(CentralAction.OnDiscoverPeripheral(
            peripheralId: peripheral.identifier.uuidString,
            peripheral: peripheral,
            rssi: RSSI,
            delegate: PeripheralDelegate(dispatch: self.dispatch)
        ))
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.dispatch(CentralAction.OnConnectPeripheral(peripheralId: peripheral.identifier.uuidString))
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.dispatch(CentralAction.OnFailToConnect(peripheralId: peripheral.identifier.uuidString, error: error))
    }

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.dispatch(CentralAction.OnDisconnect(peripheralId: peripheral.identifier.uuidString, error: error))
    }
}
