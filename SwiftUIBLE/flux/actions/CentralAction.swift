import CoreBluetooth
import SwiftUIFlux

struct CentralAction {

    struct OnUpdateState: Action {
        let state: CBManagerState
    }

    struct OnDiscoverPeripheral: Action {
        let peripheralId: String
        let peripheral: CBPeripheral
        let rssi: NSNumber
        let delegate: CBPeripheralDelegate
    }

    struct OnConnectPeripheral: Action {
        let peripheralId: String
    }

    struct OnFailToConnect: Action {
        let peripheralId: String
        let error: Error?
    }

    struct OnDisconnect: Action {
        let peripheralId: String
        let error: Error?
    }
}
