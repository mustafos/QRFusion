//
//  AppView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<AppFeature>
    private var headerHeight: CGFloat { 48 }
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
                header(for: viewStore)
                
                Group {
                    switch viewStore.selectedTab {
                    case .scan:
                        ScanView(store: store.scope(state: \.scan, action: \.scan))
                    case .preview:
                        PreviewView(store: store.scope(state: \.preview, action: \.preview))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                CapsuleTabBar(selectedTab: viewStore.binding(
                    get: \.selectedTab,
                    send: AppFeature.Action.setTab
                ))
                .padding(.bottom, 20)
            }
            .background(Color.black)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    @ViewBuilder
    private func header(for viewStore: ViewStoreOf<AppFeature>) -> some View {
        ZStack {
            switch viewStore.selectedTab {
            case .scan:
                scanHeader()
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)),
                                            removal: .opacity.combined(with: .move(edge: .top))))
                
            case .preview:
                previewHeader()
                    .transition(.asymmetric(insertion: .opacity.combined(with: .move(edge: .top)),
                                            removal: .opacity.combined(with: .move(edge: .top))))
            }
        }
        .frame(height: headerHeight)
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .animation(.easeInOut(duration: 0.25), value: viewStore.selectedTab)
    }
    
    @ViewBuilder
    private func scanHeader() -> some View {
        HStack {
            // Заглушка вместо кнопки (аналогична .share по ширине)
            Color.clear
                .frame(width: 24, height: 24)
            
            Spacer()
            
            Text("Scan QR")
                .customText(size: 16)
            
            Spacer()
            
            Button {
                // close
            } label: {
                Image(.close)
            }
        }
    }
    
    @ViewBuilder
    private func previewHeader() -> some View {
        WithViewStore(
            store.scope(state: \.preview, action: \.preview),
            observe: { $0 }
        ) { previewStore in
            HStack {
                ShareLink(
                    items: [previewStore.myAddress],
                    subject: Text("My Wallet Address"),
                    message: Text("Send funds to this address via Alien App")
                ) {
                    Image(.share)
                }
                .frame(width: 24, height: 24)
                
                Spacer()
                
                ZStack {
                    Text("Receive")
                        .customText(size: 16)
                    
                    if previewStore.isCopied {
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
                .animation(.easeInOut, value: previewStore.isCopied)
                
                Spacer()
                
                Button {
                    // close
                } label: {
                    Image(.close)
                }
            }
        }
    }
    
    
}
