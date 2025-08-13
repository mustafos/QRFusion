//
//  MainButton.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 18.07.2025.
//

import SwiftUI

typealias MainButton = View
extension MainButton {
    func customButton(bg: Color = .accent, text: Color = .white) -> some View {
        self
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(bg)
            .foregroundStyle(text)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .font(.custom("SF Pro", size: 18))
    }
}
