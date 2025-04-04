//
//  QRCodeImageView.swift
//  ScannerApp
//
//  Created by Mustafa Bekirov on 20.07.2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeImageView: View {
    let address: String

    var body: some View {
        ZStack {
            // Прозрачный фон под белым QR
            Color.clear
                .frame(width: 240, height: 240)

            if let qrImage = generateQRCode(from: address) {
                Image(uiImage: qrImage)
                    .renderingMode(.original)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
//                    .clipShape(RoundedRectangle(cornerRadius: 48, style: .continuous))
            }

            // Центр логотип
            Image("camera_mock")
                .resizable()
                .frame(width: 56, height: 56)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .shadow(radius: 4)
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(Data(string.utf8), forKey: "inputMessage")

        guard let ciImage = filter.outputImage else { return nil }

        // Инвертируем цвета (по умолчанию чёрный QR)
        let inverted = ciImage
            .applyingFilter("CIColorInvert")
            .applyingFilter("CIMaskToAlpha")

        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledImage = inverted.transformed(by: transform)

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
