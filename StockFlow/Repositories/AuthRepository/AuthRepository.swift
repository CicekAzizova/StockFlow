//
//  AuthRepository.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> LoginResponse
}

final class DefaultAuthRepository: AuthRepository {
    
    private let authService: AuthService
    private let tokenStorage: TokenStoring
    
    init(authService: AuthService, keychainService: TokenStoring) {
        self.authService = authService
        self.tokenStorage = keychainService
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let response = try await   authService.login(email: email, password: password)
        guard !response.token.isEmpty else { throw NetworkError.invalidResponse }
        try saveToken(response.token)
        return response
    }
    
    func saveToken(_ token: String) throws {
        try tokenStorage.saveToken(token)
    }
}
