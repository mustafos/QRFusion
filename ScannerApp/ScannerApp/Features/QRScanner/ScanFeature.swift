//
//  ScanFeature.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import ComposableArchitecture
import UIKit

struct ScanFeature: Reducer {
    struct State: Equatable {
        var showAlert = false
        var scannedAddress: String? = nil
    }
    
    enum Action: Equatable {
        case scanned(String)
        case alertDismissed
        case showMyCode
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .scanned(address):
                state.scannedAddress = address
                state.showAlert = true
                return .none
                
            case .alertDismissed:
                state.showAlert = false
                state.scannedAddress = nil
                return .none
                
            case .showMyCode:
                return .none
            }
        }
    }
}
