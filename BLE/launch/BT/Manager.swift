import CoreBluetooth

public class Manager {
    public static let shared = Manager()

    private var logger: Logger!
    private var cmDelegate: CBCentralManagerDelegate!
    private var centralManager: CBCentralManager!

    private var state = false
    private var peripherals: [Int: BTPeripheral] = [:]

    private var onDiscoverHandler: ((_ id: Int, _ peripheral: BTPeripheral) -> Void)?

    private init() {}
    public func initialize() {
        self.logger = Logger()
        self.cmDelegate = CentralDelegate(manager: Manager.shared, logger: self.logger)
        self.centralManager = CBCentralManager(delegate: self.cmDelegate, queue: nil)
    }

    public func getPeripheral(id: Int) -> BTPeripheral? {
        return self.peripherals[id]
    }

    public func startScan(onDiscoverHandler: @escaping (_ id: Int, _ peripheral: BTPeripheral) -> Void) {
        self.logger.debug("startScan \(self.state)")
        if !self.state {
            return;
        }
        self.onDiscoverHandler = onDiscoverHandler
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

    public func onDiscover(peripheral: CBPeripheral, rssi: NSNumber) {
        let itemPeripheral = self.getPeripheral(id: peripheral.hash);
        if itemPeripheral == nil {
            let item = Peripheral(peripheral, rssi: rssi)
            item.setDelegate(delegate: self.getPeripheralDelegate(peripheral: item))
            self.peripherals[peripheral.hash] = item
            self.onDiscoverHandler?(peripheral.hash, item)
        } else {
            itemPeripheral?.updateRssi(rssi: rssi)
        }
    }

    public func onUpdateState(state: CBManagerState) {
        self.logger.debug("onUpdateState \(state.rawValue)")
        if self.centralManager.state == CBManagerState.poweredOn {
            self.state = true
        }
    }

    private func getPeripheralDelegate(peripheral: BTPeripheral) -> CBPeripheralDelegate {
        return PeripheralDelegate(peripheral: peripheral, logger: self.logger)
    }
}
