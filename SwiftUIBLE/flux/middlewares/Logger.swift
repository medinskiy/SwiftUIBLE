import Foundation
import SwiftUIFlux

let loggingMiddleware: Middleware<AppState> = { dispatch, getState in
    return { next in
        return { action in
            #if DEBUG
                let state = getState()
                let name = __dispatch_queue_get_label(nil)
                let queueName = String(cString: name, encoding: .utf8)
                print("#Action: \(String(reflecting: action)) on queue: \(queueName ?? "??")")
//                print("#Store: \(String(describing: state))")
            #endif
            return next(action)
        }
    }
}
