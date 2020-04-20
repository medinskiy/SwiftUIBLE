
import UIKit
import SwiftUI
import SwiftUIFlux

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let controller = UIHostingController(rootView: StoreProvider(store: store) { ContentView() } )

        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
//        store.state.archiveState()
    }
}

let store = Store<AppState>(reducer: appStateReducer,
    middleware: [loggingMiddleware],
    state: AppState())

