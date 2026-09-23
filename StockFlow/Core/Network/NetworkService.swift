//
//  NetworkService.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T
}

final class DefaultNetworkService: NetworkService {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {
        
        let request: URLRequest
        
        do {
            request = try endpoint.makeRequest()
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.unknown(error)
        }
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw NetworkError.unknown(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            break
            
        case 401:
            throw NetworkError.unauthorized
            
        default:
            throw NetworkError.serverError(
                statusCode: httpResponse.statusCode
            )
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
