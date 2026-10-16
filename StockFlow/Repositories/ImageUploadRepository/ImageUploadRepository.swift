//
//  ImageUploadRepository.swift
//  StockFlow
//
//  Created by Cicek on 12.10.26.
//

import Foundation

protocol ImageUploadRepository {
    func uploadImage(_ imageData: Data) async throws -> String
}

struct ImageUploadResponse: Decodable {
    let imageUrl: String
}

final class DefaultImageUploadRepository: ImageUploadRepository {

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func uploadImage(_ imageData: Data) async throws -> String {
        let response: ImageUploadResponse = try await networkService.upload(
            ImageUploadEndpoint.upload,
            fileData: imageData,
            fieldName: "image",
            fileName: "image.jpg",
            mimeType: "image/jpeg"
        )
        return response.imageUrl
    }
}
