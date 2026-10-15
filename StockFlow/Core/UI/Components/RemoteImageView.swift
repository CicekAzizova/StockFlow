//
//  RemoteImageView.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//


import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    func set(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url as NSURL)
    }
}

struct RemoteImageView: View {
    let imageUrl: String?
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat = 10

    @State private var image: UIImage?
    @State private var didFail = false

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
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if validURL == nil || didFail {
                placeholder
            } else {
                ProgressView()
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .task(id: validURL) {
            await loadImage()
        }
    }

    private func loadImage() async {
        didFail = false

        guard let url = validURL else {
            image = nil
            return
        }

        if let cached = ImageCache.shared.image(for: url) {
            image = cached
            return
        }

        image = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let loadedImage = UIImage(data: data) else {
                didFail = true
                return
            }

            ImageCache.shared.set(loadedImage, for: url)
            image = loadedImage
        } catch is CancellationError {
            return
        } catch let error as URLError where error.code == .cancelled {
            return
        } catch {
            didFail = true
        }
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
