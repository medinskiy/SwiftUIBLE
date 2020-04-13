//
// Created by Ruslan on 05.04.2020.
// Copyright (c) 2020 Ruslan. All rights reserved.
//

import SwiftUI

final class Store: ObservableObject {
    @Published private(set) var state: AppState
    private var appReducer: Reducer<AppState, Action>;

    init(initialState: AppState, appReducer: @escaping Reducer<AppState, Action>) {
        self.state = initialState
        self.appReducer = appReducer
    }

    public func dispatch(_ action: Action) {
        if let action = action as? AsyncAction {
            action.execute(dispatch: self.dispatch)
        } else {
            appReducer(&self.state, action)
        }
    }
}
