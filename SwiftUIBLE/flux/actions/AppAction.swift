import CoreBluetooth
import SwiftUIFlux

struct AppAction {

    struct Init: Action {
        let btManager: BTManager
    }

    struct StartScan: Action {
        let stopTimer: Timer?
    }

    struct StopScan: Action {
    }

    struct Connect: Action {
        let peripheralId: String
    }

    struct Disconnect: Action {
        let peripheralId: String
    }

    struct DiscoverCharacteristics: Action {
        let serviceId: String
    }

    struct DiscoverDescriptors: Action {
        let characteristicId: String
    }
    
    struct WriteValue: Action {
        let characteristicId: String
        let value: String
    }
    
    struct ReadValue: Action {
        let characteristicId: String
    }
    
    struct ReadDescriptorValue: Action {
        let descriptorId: String
    }
    
    struct SetNotify: Action {
        let characteristicId: String
        let state: Bool
    }
}
