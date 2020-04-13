import SwiftUI
import CoreBluetooth

public protocol BTService {
    var peripheral: BTPeripheral { get }

    func getCharacteristic(id: Int) -> BTCharacteristic?
    func discoverCharacteristics()

    func onDiscoverCharacteristic(characteristic: CBCharacteristic)
    func onFailToDiscoverCharacteristic(error: Error)
}

class Service: BTService {

    private let cbService: CBService
    let peripheral: BTPeripheral

    private var characteristics: [Int: Characteristic] = [:]

    init(_ cbService: CBService, peripheral: BTPeripheral) {
        self.cbService = cbService
        self.peripheral = peripheral
    }

    public func getCharacteristic(id: Int) -> BTCharacteristic? {
        return self.characteristics[id]
    }

    public func discoverCharacteristics() {
        self.peripheral.cbPeripheral.discoverCharacteristics(nil, for: self.cbService)
    }

    func onDiscoverCharacteristic(characteristic: CBCharacteristic) {
        if self.characteristics.keys.contains(characteristic.hash) == false {
            self.characteristics[characteristic.hash] = Characteristic(characteristic, service: self)
        }
    }

    func onFailToDiscoverCharacteristic(error: Error) {
    }
}
