public protocol Action {
}

public protocol AsyncAction: Action {
    func execute(dispatch: @escaping (_ action: Action) -> Void)
}

struct AppAction {

    struct Add: Action {
        let id: Int
        let item: BTPeripheral
    }

    struct ScanStatus: Action {
        let status: Bool
    }

    struct SetActive: Action {
        let item: BTPeripheral
    }

    struct Connect: AsyncAction {
        let item: BTPeripheral

        func execute(dispatch: @escaping (_ action: Action) -> Void) {
            dispatch(AppAction.StopScan())
            Manager.shared.connect(peripheral: item)
        }
    }

    struct Disconnect: AsyncAction {
        let item: BTPeripheral

        func execute(dispatch: @escaping (_ action: Action) -> Void) {
            Manager.shared.disconnect(peripheral: item)
        }
    }

    struct StartScan: AsyncAction {
        func execute(dispatch: @escaping (_ action: Action) -> Void) {
            dispatch(AppAction.ScanStatus(status: true))
            Manager.shared.startScan() { id, peripheral in
                dispatch(AppAction.Add(id: id, item: peripheral))
            }
        }
    }

    struct StopScan: AsyncAction {
        func execute(dispatch: @escaping (_ action: Action) -> Void) {
            Manager.shared.stopScan()
            dispatch(AppAction.ScanStatus(status: false))
        }
    }
}
