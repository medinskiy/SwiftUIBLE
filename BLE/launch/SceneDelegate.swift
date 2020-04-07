//
//  SceneDelegate.swift
//  BLE
//
//  Created by Ruslan on 22.03.2020.
//  Copyright © 2020 Ruslan. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()
        let store = Store(initialState: AppState(), appReducer: appReducer);
        
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
            self.window?.rootViewController = UIHostingController(rootView: contentView.environmentObject(store))
            self.window?.makeKeyAndVisible()
        }
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
//        store.state.archiveState()
    }
}

