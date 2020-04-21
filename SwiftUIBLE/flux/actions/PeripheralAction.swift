import CoreBluetooth
import SwiftUIFlux

struct PeripheralAction {

    struct OnFailToDiscoverServices: Action {
        let error: Error
    }

    struct OnDiscoverService: Action {
        let peripheralId: String
        let serviceId:  String
        let service: CBService
    }

    struct OnFailToDiscoverCharacteristic: Action {
        let serviceId: String
        let error: Error
    }

    struct OnDiscoverCharacteristic: Action {
        let serviceId: String
        let characteristicId: String
        let characteristic: CBCharacteristic
    }

    struct OnFailToUpdateCharacteristicValue: Action {
        let characteristicId: String
        let error: Error
    }

    struct OnUpdateCharacteristicValue: Action {
        let characteristicId: String
    }

    struct OnFailToWriteCharacteristicValue: Action {
        let characteristicId: String
        let error: Error
    }

    struct OnWriteCharacteristicValue: Action {
        let characteristicId: String
    }

    struct OnFailToDiscoverDescriptors: Action {
        let characteristicId: String
        let error: Error
    }

    struct onDiscoverDescriptor: Action {
        let characteristicId: String
        let descriptorId: String
        let descriptor: CBDescriptor
    }

    struct OnFailToUpdateDescriptorValue: Action {
        let descriptorId: String
        let error: Error
    }

    struct OnUpdateDescriptorValue: Action {
        let descriptorId: String
    }

    struct OnFailToWriteDescriptorValue: Action {
        let descriptorId: String
        let error: Error
    }

    struct OnWriteDescriptorValue: Action {
        let descriptorId: String
    }
}
