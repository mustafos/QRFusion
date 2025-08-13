//
//  CameraPreviewView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 19.07.2025.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession
    var onLayerReady: ((AVCaptureVideoPreviewLayer) -> Void)? = nil
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = UIScreen.main.bounds
        
        DispatchQueue.main.async {
            onLayerReady?(previewLayer)
        }
        
        view.layer.addSublayer(previewLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
