//
//  SceneDelegate.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 19.07.2025.
//

import UIKit
import SwiftUI
import ComposableArchitecture

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = ShakeMotionNotifier(windowScene: windowScene)
        let rootView = AppView(store: store)
            .environmentObject(window)

        let hostingController = UIHostingController(rootView: rootView)
        hostingController.overrideUserInterfaceStyle = .dark
        
        window.rootViewController = hostingController
        window.overrideUserInterfaceStyle = .dark
        self.window = window
        window.makeKeyAndVisible()
    }
}
