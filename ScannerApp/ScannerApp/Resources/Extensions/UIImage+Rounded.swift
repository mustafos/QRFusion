//
//  UIImage+Rounded.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 20.07.2025.
//

import UIKit

extension UIImage {
    /// Renders the image with rounded corners using Core Graphics
    func withRoundedCorners(radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        return UIGraphicsImageRenderer(size: size).image { _ in
            UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
            draw(in: rect)
        }
    }
}

