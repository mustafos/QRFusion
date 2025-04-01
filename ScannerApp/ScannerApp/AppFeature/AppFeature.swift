//
//  AppFeature.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import ComposableArchitecture
import CasePaths

enum ScreenState: Equatable {
    case scan(ScanFeature.State)
    case preview(PreviewFeature.State)
}

struct AppFeature: Reducer {
    struct State: Equatable {
        var selectedTab: Tab = .scan
        var scan = ScanFeature.State()
        var preview = PreviewFeature.State(myAddress: "0xDEADBEEF1234567890")
    }
    
    @CasePathable
    enum Action: Equatable {
        case setTab(Tab)
        case scan(ScanFeature.Action)
        case preview(PreviewFeature.Action)
    }
    
    enum Tab: Int, CaseIterable {
        case scan, preview
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.scan, action: \.scan) {
            ScanFeature()
        }
        Scope(state: \.preview, action: \.preview) {
            PreviewFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .setTab(let tab):
                state.selectedTab = tab
                return .none
                
            case .scan(.scanned(let address)):
                state.preview.myAddress = address
                return .none
                
            case .preview(.backTapped):
                state.selectedTab = .scan
                return .none
                
            default:
                return .none
            }
        }
    }
}

extension AppFeature.Tab {
    var title: String {
        switch self {
        case .scan: return "Scan"
        case .preview: return "My Code"
        }
    }
}
