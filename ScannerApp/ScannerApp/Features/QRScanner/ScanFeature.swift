//
//  ScanFeature.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import ComposableArchitecture
import UIKit
import Vision
import SwiftUI

struct ScanFeature: Reducer {
    struct State: Equatable {
        var showAlert = false
        var scannedAddress: String? = nil
        var isCameraActive = true
    }
    
    enum Action: Equatable {
        case scanned(String)
        case alertDismissed
        case showMyCode
        case updateCamera(Bool)
        case scanImage(UIImage)
        case scannedFromImage(String?)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .scanned(address):
                state.scannedAddress = address
                state.showAlert = true
                state.isCameraActive = false
                return .none
                
            case .alertDismissed:
                state.showAlert = false
                state.scannedAddress = nil
                state.isCameraActive = true
                return .none
                
            case .showMyCode:
                return .none
                
            case let .updateCamera(isActive):
                state.isCameraActive = isActive
                return .none
                
            case let .scanImage(image):
                return .run { send in
                    let result = await Self.scanQRCode(from: image)
                    await send(.scannedFromImage(result))
                }
                
            case let .scannedFromImage(code):
                guard let code else { return .none }
                return .send(.scanned(code))
            }
        }
    }
    
    static func scanQRCode(from image: UIImage) async -> String? {
        guard let cgImage = image.cgImage else { return nil }
        
        return await withCheckedContinuation { continuation in
            let request = VNDetectBarcodesRequest { request, error in
                guard error == nil else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let result = request.results?.first as? VNBarcodeObservation
                continuation.resume(returning: result?.payloadStringValue)
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: nil)
            }
        }
    }
}
