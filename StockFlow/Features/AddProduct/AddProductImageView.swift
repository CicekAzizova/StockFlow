//
//  AddProductImageView.swift
//  StockFlow
//
//  Created by Cicek on 28.09.26.
//

import SwiftUI
import PhotosUI
import UIKit

struct AddProductImageView: View {

    @Binding var selectionItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    
    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Product images")
                .font(.inter(.regular, size: 16))

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 12) {

                    // Selected images
                    ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in

                        ZStack(alignment: .topTrailing) {

                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 85, height: 85)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 12)
                                )

                            Button {
                                selectedImages.remove(at: index)
                                selectionItems.remove(at: index)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.white, .red)
                                    .font(.system(size: 20))
                            }
                            .offset(x: 6, y: -6)
                        }
                    }

                    if selectionItems.count < 5 {

                        PhotosPicker(
                            selection: $selectionItems,
                            maxSelectionCount: 5,
                            matching: .images
                        ) {

                            VStack(spacing: 6) {

                                Image(systemName: "camera.fill")
                                    .font(.system(size: 24))

                                Text("Add images")
                                    .font(.inter(.regular, size: 14))
                            }
                            .foregroundStyle(.brandPrimary)
                            .frame(width: 120, height: 85)
                            .background(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                        }
                    }
                }
                .padding(12)
            }
            .frame(height: 110)
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        .gray,
                        style: StrokeStyle(
                            lineWidth: 1,
                            dash: [6, 4]
                        )
                    )
            }
        }
        .onChange(of: selectionItems) { _, newItems in

            Task {
                var loadedImages: [UIImage] = []

                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        loadedImages.append(image)
                    }
                }

                await MainActor.run {
                    selectedImages = loadedImages
                }
            }
        }
    }
}
