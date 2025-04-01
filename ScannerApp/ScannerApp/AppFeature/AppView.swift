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
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 0) {
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
}
