//
// Created by Ruslan on 05.04.2020.
// Copyright (c) 2020 Ruslan. All rights reserved.
//

public typealias Reducer<AppState, Action> = (_ state: inout AppState, _ action: Action) -> Void

func appReducer(state: inout AppState, action: Action) {
    switch action {

    case let action as AppAction.Add:
        if let index = state.items.firstIndex(of: action.item) {
            state.items[index] = action.item
        } else {
            print(action.item.name)
            state.items.append(action.item)
        }

    default:
        break;
    }
}
