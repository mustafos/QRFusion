//
//  ViewfinderOverlay.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 19.07.2025.
//

import SwiftUI

struct ViewfinderOverlay: View {
    var body: some View {
        ZStack {
            Color.clear
            Image("frame")
                .resizable()
                .frame(width: 220, height: 220)
                .blendMode(.screen)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
        
    }
}
