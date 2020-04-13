public typealias Reducer<AppState, Action> = (_ state: inout AppState, _ action: Action) -> Void

func appReducer(state: inout AppState, action: Action) {
    switch action {

    case let action as AppAction.Add:
        state.itemsList.append(action.id)
        state.items[action.id] = action.item

    case let action as AppAction.ScanStatus:
        state.scanStatus = action.status

    case let action as AppAction.SetActive:
        state.activeItem = action.item

    default:
        break;
    }
}
