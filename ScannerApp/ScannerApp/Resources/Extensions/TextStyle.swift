//
//  TextStyle.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 18.07.2025.
//

import SwiftUI

typealias TextStyle = Text

extension TextStyle {
    func customText(size: CGFloat = 14, color: Color = .white) -> some View {
        return self
            .multilineTextAlignment(.center)
            .font(.custom("SF Pro",size: size))
            .foregroundStyle(color)
    }
}
