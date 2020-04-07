//
// Created by Ruslan on 05.04.2020.
// Copyright (c) 2020 Ruslan. All rights reserved.
//

import CoreBluetooth

public protocol Action {}

public protocol AsyncAction: Action {
    func execute(dispatch: @escaping (_ action: Action) -> Void)
}

fileprivate let btManager = BluetoothController();

struct AppAction {

    struct Add: Action {
        let item: Item
    }

    struct StartScan: AsyncAction {
        func execute(dispatch: @escaping (_ action: Action) -> Void) {
            btManager.startScan { peripheral, rssi in
                if let name = peripheral.name {
                    let item = Item(id: name, name: name, rssi: rssi);
                    dispatch(AppAction.Add(item: item))
                }
            }
        }
    }

    struct StopScan: AsyncAction {
        func execute(dispatch: @escaping (_ action: Action) -> Void) {
            btManager.stopScan()
        }
    }
}
