//
//  RemoteImageView.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//


import SwiftUI

struct RemoteImageView: View {
    let imageUrl: String?
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat = 10

    private var validURL: URL? {
        guard let imageUrl else { return nil }

        let trimmedURL = imageUrl.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanURL: String

        if trimmedURL.hasPrefix("["),
           let openingParenthesis = trimmedURL.firstIndex(of: "("),
           let closingParenthesis = trimmedURL.lastIndex(of: ")"),
           openingParenthesis < closingParenthesis {
            cleanURL = String(
                trimmedURL[
                    trimmedURL.index(after: openingParenthesis)..<closingParenthesis
                ]
            )
        } else {
            cleanURL = trimmedURL
        }

        return AppConfig.imageURL(from: cleanURL)
    }

    var body: some View {
        Group {
            if let validURL {
                AsyncImage(url: validURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()

                    case .failure:
                        placeholder

                    case .empty:
                        ProgressView()

                    @unknown default:
                        placeholder
                    }
                }
            } else {
                placeholder
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .font(.system(size: 22))
            .foregroundStyle(.secondary)
            .frame(width: width, height: height)
            .background(.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
