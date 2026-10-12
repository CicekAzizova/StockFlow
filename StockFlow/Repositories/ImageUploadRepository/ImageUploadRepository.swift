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

enum ImageUploadError: LocalizedError {
    case invalidURL
    case invalidResponse
    case uploadFailed(Int)
    case missingToken

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Image upload URL is invalid."
        case .invalidResponse: return "Invalid server response."
        case .uploadFailed(let statusCode): return "Image upload failed. Status code: \(statusCode)"
        case .missingToken: return "Authentication token not found."
        }
    }
}

final class DefaultImageUploadRepository: ImageUploadRepository {

    private let tokenStorage: TokenStoring
    private let session: URLSession

    init(tokenStorage: TokenStoring, session: URLSession = .shared) {
        self.tokenStorage = tokenStorage
        self.session = session
    }

    func uploadImage(_ imageData: Data) async throws -> String {
        guard let token = try tokenStorage.readToken(), !token.isEmpty else {
            throw ImageUploadError.missingToken
        }
        guard let url = URL(string: "\(AppConfig.baseURL)/uploads/images") else {
            throw ImageUploadError.invalidURL
        }

        let boundary = UUID().uuidString

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        request.httpBody = body

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageUploadError.invalidResponse
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ImageUploadError.uploadFailed(httpResponse.statusCode)
        }

        return try JSONDecoder().decode(ImageUploadResponse.self, from: data).imageUrl
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
