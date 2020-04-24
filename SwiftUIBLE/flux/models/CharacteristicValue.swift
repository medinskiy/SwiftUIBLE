import SwiftUI

public struct ValueParser {
    public static func getParser(serviceUUID: String, characteristicUUID: String) -> CharacteristicValue {
        let serviceType = ServiceType(rawValue: "0x\(serviceUUID)") ?? ServiceType.any
        let characteristicType = CharacteristicType(rawValue: "0x\(characteristicUUID)") ?? CharacteristicType.any
        
        return parsers[serviceType]?[characteristicType] ?? StringValue.self()
    }
}


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

public protocol CharacteristicValue {
    func parse(data: Data) -> String
}

private struct NumberValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        let hex = data.reduce("", { return $0 + String(format: "%02X", $1) })
        return String(Int(hex, radix: 16) ?? 0)
    }
}

private struct StringValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        let string = String(decoding: data, as: UTF8.self)
        return string.isEmpty ? "" : string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct BatteryValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        "\(NumberValue().parse(data: data))%"
    }
}

private struct CurrentTimeValue: CharacteristicValue {
    private let week = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    public func parse(data: Data) -> String {
        if data.isEmpty {
            return ""
        }
        
        let year: UInt16 = data.withUnsafeBytes { $0.load(as: UInt16.self) }
        let month: String = String(format: "%02u", data[2])
        let day: String = String(format: "%02u", data[3])
        let hours: String = String(format: "%02u", data[4])
        let minutes: String = String(format: "%02u", data[5])
        let seconds: String = String(format: "%02u", data[6])
        let dOfWeek: Int = Int(data[7])
        let fraction: Int = Int(data[8]) * 1000 / 256
        let adjReason: UInt8 = UInt8(data[9])
        
        return "\(week[Int(dOfWeek)]), \(day).\(month).\(year) \(hours):\(minutes):\(seconds).\(fraction) AdjReason: \(adjReason)"
    }
}

private struct LocalTimeInfoValue: CharacteristicValue {
    public func parse(data: Data) -> String {
        if data.isEmpty {
            return ""
        }
        let dstValue: Int8 = Int(data[1]) > 0 ? 1 : 0
        let timeZoneValue: Int8 = Int8(bitPattern: UInt8(data[0])) / 4
        let timeZone = timeZoneValue + dstValue

        return "UTC\(timeZone < 0 ? "" : "+")\(timeZone):00 \(dstValue != 0 ? "Daylight Saving Time" : "")"
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
