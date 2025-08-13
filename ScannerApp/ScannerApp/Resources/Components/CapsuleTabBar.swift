//
//  CapsuleTabBar.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 18.07.2025.
//

import SwiftUI

struct CapsuleTabBar: View {
    @Binding var selectedTab: AppFeature.Tab
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.regularMaterial)
                .frame(height: 56)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            
            GeometryReader { geometry in
                let tabCount = CGFloat(AppFeature.Tab.allCases.count)
                let width = geometry.size.width / tabCount
                let index = CGFloat(AppFeature.Tab.allCases.firstIndex(of: selectedTab) ?? 0)
                
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .frame(width: width - 8, height: 48)
                        .offset(x: width * index + 4)
                        .animation(.easeInOut(duration: 0.25), value: selectedTab)
                    
                    HStack(spacing: 0) {
                        ForEach(AppFeature.Tab.allCases, id: \.self) { tab in
                            Button {
                                withAnimation(.smooth) {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    selectedTab = tab
                                }
                            } label: {
                                Text(tab.title)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
            }
            .clipShape(Capsule())
        }
        .frame(height: 56)
        .padding(.horizontal, 32)
    }
}
