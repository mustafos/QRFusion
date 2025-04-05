//
//  CIImage+Extensions.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 20.07.2025.
//

import UIKit
import CoreImage

extension CIImage {
    /// Inverts black ↔ white
    var inverted: CIImage? {
        CIFilter(name: "CIColorInvert")?.apply(input: self)
    }
    
    /// Converts black to transparent (alpha mask)
    var blackTransparent: CIImage? {
        CIFilter(name: "CIMaskToAlpha")?.apply(input: self)
    }
    
    /// Makes background transparent
    var transparent: CIImage? {
        inverted?.blackTransparent
    }
    
    /// Applies a tint color to the QR code
    func tinted(using color: UIColor) -> CIImage? {
        guard let transparentQR = self.transparent,
              let colorFilter = CIFilter(name: "CIConstantColorGenerator"),
              let composite = CIFilter(name: "CIMultiplyCompositing") else { return nil }
        
        colorFilter.setValue(CIColor(color: color), forKey: kCIInputColorKey)
        guard let colorImage = colorFilter.outputImage else { return nil }
        
        composite.setValue(colorImage, forKey: kCIInputImageKey)
        composite.setValue(transparentQR, forKey: kCIInputBackgroundImageKey)
        
        return composite.outputImage
    }
    
    /// Overlays an image (e.g., logo) centered on top
    func combined(with overlay: CIImage) -> CIImage? {
        guard let filter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        
        let centerTransform = CGAffineTransform(
            translationX: extent.midX - overlay.extent.width / 2,
            y: extent.midY - overlay.extent.height / 2
        )
        filter.setValue(overlay.transformed(by: centerTransform), forKey: kCIInputImageKey)
        filter.setValue(self, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage
    }
}

private extension CIFilter {
    /// Helper to apply input image to filter
    func apply(input: CIImage) -> CIImage? {
        setValue(input, forKey: kCIInputImageKey)
        return outputImage
    }
}
