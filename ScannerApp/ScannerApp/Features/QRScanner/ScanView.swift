//
//  ScanView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 17.07.2025.
//

import SwiftUI
import CodeScanner
import ComposableArchitecture
import AVFoundation
import PhotosUI
import Vision

struct ScanView: View {
    let store: StoreOf<ScanFeature>
    
    @EnvironmentObject var shake: ShakeMotionNotifier
    @State private var isGalleryPresented = false
    @State private var isTorchOn = false
    @State private var showScanner = true
    @State private var selectedItem: PhotosPickerItem?
    
    private let padding: CGFloat = 20
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    HStack {
                        Button {
                            // mock button
                        } label: {
                            Image("empty").frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        Text("Scan QR")
                            .customText(size: 16)
                        
                        Spacer()
                        
                        Button {
                            // close action
                        } label: {
                            Image(.close)
                        }
                    }
                    .padding(.horizontal, padding)
                    .padding(.top, 12)
                    
//                    Spacer()
                    
                    // MARK: - Scanner
                    if showScanner {
                        ZStack {
                            CodeScannerView(
                                codeTypes: [.qr],
                                showViewfinder: true,
                                simulatedData: "0xDEADBEEF1234567890",
                                isTorchOn: isTorchOn
                            ) { result in
                                switch result {
                                case .success(let res):
                                    viewStore.send(.scanned(res.string))
                                    showScanner = false
                                case .failure(let error):
                                    print("Scanning failed: \(error)")
                                }
                            }
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .ignoresSafeArea()
                            
//                            Image("frame")
                        }//.padding(.top, 100)
                    }
                    
//                    Spacer()
                    
                    // MARK: - Bottom controls
                    HStack(spacing: 40) {
                        Button {
                            isGalleryPresented = true
                        } label: {
                            VStack {
                                Image(systemName: "eye.fill")
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                Text("Gallery")
                                    .customText(size: 12)
                            }
                        }
                        
                        Divider().frame(height: 36)
                        
                        Button {
                            toggleTorch()
                        } label: {
                            VStack {
                                Image(systemName: "flashlight.on.fill")
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                                Text("Flashlight")
                                    .customText(size: 12)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .photosPicker(isPresented: $isGalleryPresented, selection: $selectedItem)
            .onChange(of: selectedItem) { newItem in
                guard let item = newItem else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data),
                       let address = await scanQRCode(from: image) {
                        viewStore.send(.scanned(address))
                        showScanner = false
                    }
                }
            }
            .onReceive(shake.$didShake) { didShake in
                guard didShake else { return }
                viewStore.send(.scanned("8TZLxqVmNf3p9zAYnbtQgXpABC123XYZ"))
                shake.didShake = false
            }
            .sheet(isPresented: viewStore.binding(
                get: \.showAlert,
                send: .alertDismissed
            )) {
                VStack(spacing: 16) {
                    Text("This address is outside of Alien App")
                        .customText(size: 24)
                    Text("We don’t know who is the owner. Please, make sure that address is correct and proceed with caution")
                        .customText(color: .gray)
                    
                    CopyAddressView(address: "8TZLxqVmNf3p9zAYnbtQgXpABC123XYZ", needsCopy: false) { }
                    
                    Button {
                        viewStore.send(.alertDismissed)
                    } label: {
                        Text("I understand")
                            .customButton()
                    }
                    
                    Button("Close") {
                        viewStore.send(.alertDismissed)
                    }
                }
                .padding(.horizontal, 8)
//                .presentationBackground(.ultraThinMaterial)
//                .presentationCornerRadius(24)
                .presentationDragIndicator(.visible)
                .presentationDetents([.medium])
            }
        }
    }
    
    private func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        try? device.lockForConfiguration()
        isTorchOn.toggle()
        device.torchMode = isTorchOn ? .on : .off
        device.unlockForConfiguration()
    }
    
    private func scanQRCode(from image: UIImage) async -> String? {
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
