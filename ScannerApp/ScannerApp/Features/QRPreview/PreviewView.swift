//
//  PreviewView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import SwiftUI
import ComposableArchitecture
import CoreImage.CIFilterBuiltins

struct PreviewView: View {
    let store: StoreOf<PreviewFeature>
    @Binding var qrImageToShare: UIImage?
    private let padding: CGFloat = 20
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    
                    Spacer(minLength: 16)
                    
                    // MARK: - Handle
                    Text("@mustafosID")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(
                            LinearGradient(colors: [.accent, .mint], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    // MARK: - QR Image
                    QRCodeImageView(
                        address: viewStore.myAddress,
                        color: .white,
                        logo: UIImage(named: "camera_mock"),
                        onImageGenerated: { image in
                            qrImageToShare = image
                        }
                    )
                    
                    // MARK: - Info
                    VStack(spacing: 4) {
                        Image(.coins)
                        Text("Aliencoin, Solana, US Dollar")
                            .customText()
                        Text("To send, use Alien or Solana network only")
                            .customText(size: 12, color: .gray)
                    }
                    
                    // MARK: - Address
                    CopyAddressView(address: viewStore.myAddress) {
                        viewStore.send(.copyTapped)
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                    .padding(.top, 12)
                    .padding(.horizontal, padding)
                    
                    Spacer()
                }
                .padding(.bottom, 40)
            }
        }
    }
}
