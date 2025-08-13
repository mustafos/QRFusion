//
//  String+QRCode.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 20.07.2025.
//

import UIKit
import CoreImage

extension String {
    /// Generates a custom QR code with color and optional logo
    func qrImage(using color: UIColor, logo: UIImage? = nil, scale: CGFloat = 12) -> CIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data(using: .ascii), forKey: "inputMessage")
        
        guard var qr = filter.outputImage?.transformed(by: .init(scaleX: scale, y: scale)) else {
            return nil
        }
        
        // Tint the QR code
        qr = qr.tinted(using: color) ?? qr
        
        // Add logo if provided
        if let logo = logo?.withRoundedCorners(radius: logo!.size.width / 5),
           let cgLogo = logo.cgImage {
            let logoCI = CIImage(cgImage: cgLogo)
                .transformed(by: .init(scaleX: 0.05, y: 0.05)) // Scale logo
            return qr.combined(with: logoCI)
        }
        
        return qr
    }
}
