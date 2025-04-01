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
    
    private let padding: CGFloat = 20
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // MARK: - Header
                    HStack {
                        ShareLink(
                            items: [viewStore.myAddress],
                            subject: Text("My Wallet Address"),
                            message: Text("Send funds to this address via Alien App")
                        ) {
                            Image(.share)
                        }

                        Spacer()

                        ZStack {
                            Text("Receive")
                                .customText(size: 16)

                            if viewStore.isCopied {
                                HStack(spacing: 4) {
                                    Image(systemName: "checkmark.circle.fill")
                                    Text("Address copied").customText()
                                }
                                .foregroundStyle(Color.accent, Color.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue)
                                .clipShape(Capsule())
                                .transition(.opacity)
                            }
                        }
                        .frame(height: 36)
                        .animation(.easeInOut, value: viewStore.isCopied)

                        Spacer()

                        Button {
                            // close action
                        } label: {
                            Image(.close)
                        }
                    }
                    .padding(.horizontal, padding)
                    .padding(.top, 12)
                    
                    Spacer(minLength: 16)

                    // MARK: - Handle
                    Text("@mustafosID")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(
                            LinearGradient(colors: [.accent, .mint], startPoint: .leading, endPoint: .trailing)
                        )
                    
                    // MARK: - QR Image
                    Image("camera_mock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 240)
                        .overlay(
                            RoundedRectangle(cornerRadius: 48)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .cornerRadius(48)

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
