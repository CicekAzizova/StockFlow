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
    case serverError(statusCode: Int)
    case decodingError
    case encodingError
    case unknown(Error)
    case unauthorized

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "Invalid URL."

        case .invalidResponse:
            return "Invalid server response."

        case .serverError(let statusCode):
            return "Server error. Status code: \(statusCode)"

        case .decodingError:
            return "Failed to decode server response."

        case .encodingError:
            return "Failed to encode request."

        case .unknown(let error):
            return error.localizedDescription

        case .unauthorized:
            return "Unauthorized request."
        }
    }
}
