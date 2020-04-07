
import UIKit
import CoreBluetooth

class BluetoothController: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {
    private var enabled = false;
    private var manager: CBCentralManager! = nil
    private var didDiscover: ((_ peripheral: CBPeripheral, _ rssi: NSNumber) -> Void)!
    
    override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    public func startScan(didDiscover: @escaping (_ peripheral: CBPeripheral, _ rssi: NSNumber) -> Void) {
        self.didDiscover = didDiscover
        if self.enabled {
            self.manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    public func stopScan() {
        self.manager.stopScan()
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn{
            enabled = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.didDiscover(peripheral, RSSI)
        
        //        self.peripheral = peripheral
        //        self.peripheral?.delegate = self
        //
        //        self.manager.connect(peripheral, options: nil)
        //        self.manager.stopScan()
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        peripheral.readRSSI()
    }
    
//    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
//        didDiscover(peripheral, rssi: RSSI)
//        peripheral.readRSSI()
//    }
}
