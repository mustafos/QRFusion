//
//  PreviewFeature.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import ComposableArchitecture
import UIKit

struct PreviewFeature: Reducer {
    struct State: Equatable {
        var myAddress: String
        var isCopied: Bool = false
    }
    
    enum Action: Equatable {
        case copyTapped
        case copyReset
        case backTapped
    }
    
    @Dependency(\.continuousClock) var clock
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .copyTapped:
                UIPasteboard.general.string = state.myAddress
                state.isCopied = true
                return .run { send in
                    try await clock.sleep(for: .seconds(2))
                    await send(.copyReset)
                }
                
            case .copyReset:
                state.isCopied = false
                return .none
                
            case .backTapped:
                return .none
            }
        }
    }
}
