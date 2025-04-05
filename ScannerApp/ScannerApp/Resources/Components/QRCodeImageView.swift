//
//  QRCodeImageView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 20.07.2025.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCodeImageView: View {
    let address: String
    let color: UIColor
    let logo: UIImage?
    var onImageGenerated: ((UIImage) -> Void)? = nil

    var body: some View {
        ZStack {
            if let ciImage = address.qrImage(using: color, logo: logo),
               let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)

                Image(uiImage: uiImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .onAppear {
                        onImageGenerated?(uiImage)
                    }
            }
        }
    }
}
