//
//  Item.swift
//  BLE
//
//  Created by Ruslan on 06.04.2020.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import SwiftUI

struct Item: Identifiable {
    var id: String
    var name: String
    var rssi: NSNumber
}

extension Item: Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
