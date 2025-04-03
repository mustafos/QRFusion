//
//  CameraService.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 19.07.2025.
//

import AVFoundation

final class CameraService: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    let session = AVCaptureSession()
    @Published var scannedCode: String?
    @Published var isTorchOn = false
    @Published var qrBounds: CGRect = .zero
    weak var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let metadataOutput = AVCaptureMetadataOutput()
    private var isSessionRunning = false
    
    override init() {
        super.init()
        configure()
    }
    
    private func configure() {
        session.beginConfiguration()
        
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("⚠️ Failed to add camera input")
            return
        }
        
        session.addInput(input)
        
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        session.commitConfiguration()
    }
    
    func startSessionIfNeeded() {
        guard !isSessionRunning else { return }
        isSessionRunning = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
    }
    
    func stopSessionIfNeeded() {
        guard isSessionRunning else { return }
        isSessionRunning = false
        
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              object.type == .qr,
              let stringValue = object.stringValue,
              let previewLayer = previewLayer else { return }
        
        if let transformedObject = previewLayer.transformedMetadataObject(for: object) {
            DispatchQueue.main.async {
                self.qrBounds = transformedObject.bounds
            }
        }
        
        stopSessionIfNeeded()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.scannedCode = stringValue
        }
    }
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else {
            print("⚠️ Torch not available")
            return
        }
        
        do {
            try device.lockForConfiguration()
            isTorchOn.toggle()
            device.torchMode = isTorchOn ? .on : .off
            device.unlockForConfiguration()
            print("🔦 Torch is now \(isTorchOn ? "ON" : "OFF")")
        } catch {
            print("⚠️ Torch error: \(error)")
        }
    }
}
