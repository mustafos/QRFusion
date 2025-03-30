//
//  AppDelegate.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import UIKit
import SwiftUI
import ComposableArchitecture

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let shakeWindow = ShakeMotionNotifier(frame: UIScreen.main.bounds)
        let rootView = AppView(store: store).environmentObject(shakeWindow)
        
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.overrideUserInterfaceStyle = .dark
        
        shakeWindow.rootViewController = hostingController
        shakeWindow.overrideUserInterfaceStyle = .dark
        shakeWindow.makeKeyAndVisible()
        self.window = shakeWindow
        
        return true
    }
}
