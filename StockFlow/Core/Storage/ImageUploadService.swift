//
//  ImageUploadService.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//

import Foundation

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
        case .invalidURL:
            return "Image upload URL is invalid."
        case .invalidResponse:
            return "Invalid server response."
        case .uploadFailed(let statusCode):
            return "Image upload failed. Status code: \(statusCode)"
        case .missingToken:
            return "Authentication token not found."
        }
    }
}

final class ImageUploadService {

    private let baseURL = "http://localhost:3000"

    func uploadImage(_ imageData: Data, token: String) async throws -> String {
        guard let url = URL(string: "\(baseURL)/uploads/images") else {
            throw ImageUploadError.invalidURL
        }

        let boundary = UUID().uuidString

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "multipart/form-data; boundary=\(boundary)",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            "Bearer \(token)",
            forHTTPHeaderField: "Authorization"
        )

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw ImageUploadError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw ImageUploadError.uploadFailed(httpResponse.statusCode)
        }

        let result = try JSONDecoder().decode(ImageUploadResponse.self, from: data)
        return result.imageUrl
    }
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
