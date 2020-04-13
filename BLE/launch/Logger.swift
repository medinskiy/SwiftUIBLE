//
//  Logger.swift
//  BLE
//
//  Created by Ruslan on 09.04.2020.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import Foundation

struct Logger {
    func debug(_ message: String) -> Void {
        print("DEBUG: \(message)")
    }
    func error(_ message: String, _ error: Error? = nil) -> Void {
        if let e = error {
            print("ERROR: \(message) with error \(e)")
        } else {
            print("ERROR: \(message)")
        }
    }
}
