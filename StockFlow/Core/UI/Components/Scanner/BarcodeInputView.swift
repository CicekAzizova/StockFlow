//
//  BarcodeInputView.swift
//  StockFlow
//
//  Created by Cicek on 13.10.26.
//

import SwiftUI

struct BarcodeInputView: View {
    var placeholder = "Enter SKU manually"
    var showsManualEntry = true
    let onCode: (String) -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            camera
                .ignoresSafeArea()
            
            if showsManualEntry {
                ManualCodeEntryView(placeholder: placeholder, onSubmit: onCode)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                    .padding(.bottom, 8)
            }
        }
    }

    @ViewBuilder
    private var camera: some View {
        if BarcodeScannerView.isAvailable {
            BarcodeScannerView(onScan: onCode)
        } else {
            ContentUnavailableView(
                "Camera unavailable",
                systemImage: "camera.slash",
                description: Text(
                    showsManualEntry
                    ? "Enter the code manually below."
                    : "Close this screen and type the SKU."
                )
            )
            .foregroundStyle(.white)
        }
    }
}
