import SwiftUI

private enum ServiceType: String {
    case battery = "0x180F"
    case deviceInformation = "0x180A"
    case time = "0x1805"
    case any = "0x0"
}

private enum CharacteristicType: String {
    case currentTime = "0x2A2B"
    case localTimeInfo = "0x2A0F"
    case any = "0x0"
}

extension Data {
    var hexString: String {
        var hex:String = ""
        for byte in self {
            hex += String(format: "%02X", byte)
        }
        return hex
    }
}

private let parsers: [ServiceType: [CharacteristicType: CharacteristicValue]] = [
    ServiceType.battery: [
        CharacteristicType.any: BatteryValue(),
    ],
    ServiceType.deviceInformation: [
        CharacteristicType.any: StringValue(),
    ],
    ServiceType.time: [
        CharacteristicType.currentTime: CurrentTimeValue(),
        CharacteristicType.localTimeInfo: LocalTimeInfoValue(),
        CharacteristicType.any: NumberValue(),
    ]
]

public struct ValueParser {
    public static func getParser(serviceUUID: String, characteristicUUID: String) -> CharacteristicValue {
        let serviceType = ServiceType(rawValue: "0x\(serviceUUID)") ?? ServiceType.any
        let characteristicType = CharacteristicType(rawValue: "0x\(characteristicUUID)") ?? CharacteristicType.any
        
        return parsers[serviceType]?[characteristicType] ?? StringValue.self()
    }
}

public protocol CharacteristicValue {
    func parse(data: Data) -> String
}

private struct NumberValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        String(Int(data.hexString, radix: 16) ?? 0)
    }
}

private struct StringValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        String(decoding: data, as: UTF8.self)
    }
}

private struct BatteryValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        "\(Int(data.hexString, radix: 16) ?? 0)%"
    }
}

private struct CurrentTimeValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        NumberValue().parse(data: data)
    }
}

private struct LocalTimeInfoValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        NumberValue().parse(data: data)
    }
}


//1805 service
//2A2B Current Time ("E4070417001E19047102")
//2A0F Local Time Information ("0804")
