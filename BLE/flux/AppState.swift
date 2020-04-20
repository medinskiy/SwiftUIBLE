import SwiftUIFlux

struct AppState: FluxState {
    
    var manager: BTManager?
    var btStatus: Bool = false
    var scanStatus: Bool = false
    
    var peripherals: [String: BTPeripheral] = [:]
    var peripheralsList: [String] = []

    var services: [String: BTService] = [:]
    var servicesList: [String] = []

    var characteristics: [String: BTCharacteristic] = [:]
    var characteristicsList: [String: [String]] = [:]

    var descriptors: [String: BTDescriptor] = [:]
    var descriptorsList: [String: [String]] = [:]
    
    func cleared() -> AppState {
        var state = self
        state.descriptorsList.removeAll()
        state.descriptors.removeAll()
        state.characteristicsList.removeAll()
        state.characteristics.removeAll()
        state.servicesList.removeAll()
        state.services.removeAll()
        
        return state
    }
}
