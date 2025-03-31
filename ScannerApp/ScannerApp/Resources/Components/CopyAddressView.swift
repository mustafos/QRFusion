//
//  CopyAddressView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 18.07.2025.
//

import SwiftUI

struct CopyAddressView: View {
    let address: String
    var needsCopy: Bool = true
    let onCopy: () -> Void
    
    var body: some View {
        HStack(spacing: 8) {
            Text(shortenAddress(address))
                .customText()
                .lineLimit(1)
                .truncationMode(.middle)
                .multilineTextAlignment(.center)
            if needsCopy {
                Button(action: onCopy) {
                    Image(.copy).frame(width: 16, height: 16)
                }
            }
        }
        .frame(height: 40)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.12))
        .clipShape(Capsule())
    }
    
    private func shortenAddress(_ address: String) -> String {
        guard address.count > 12 else { return address }
        let prefix = address.prefix(6)
        let suffix = address.suffix(6)
        return "\(prefix)...\(suffix)"
    }
}
