//
//  NetworkError.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidUrl
    case invalidResponse
    case serverError(statusCode: Int, message: String?)
    case decodingError(Error)
    case encodingError
    case unknown(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL."

        case .invalidResponse:
            return "Invalid server response."

        case .serverError(let statusCode, let message):
            return message ?? "Server error. Status code: \(statusCode)"

        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"

        case .encodingError:
            return "Failed to encode request."

        case .unknown(let error):
            return error.localizedDescription

        case .unauthorized:
            return "Unauthorized request."
        }
    }
}
