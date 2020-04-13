struct AppState {
    var scanStatus: Bool = false
    var items: [Int: BTPeripheral] = [:]
    var itemsList: [Int] = []
    var activeItem: BTPeripheral? = nil
}
