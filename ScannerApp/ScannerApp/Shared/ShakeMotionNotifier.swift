//
//  ShakeMotionNotifier.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import UIKit
import Combine

/// UIKit-based observable to detect shake motion
final class ShakeMotionNotifier: UIWindow, ObservableObject {
    @Published var didShake = false
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        DispatchQueue.main.async {
            self.didShake = true
        }
    }
}
