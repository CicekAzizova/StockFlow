//
//  AuthService.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

protocol AuthService {
    func login(email: String, password: String) async throws -> LoginResponse
}

final class DefaultAuthService: AuthService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    func login(email: String, password: String) async throws -> LoginResponse {
        let endPoint = AuthEndpoint.login(
            email: email,
            password: password
        )
       return try await networkService.request(endPoint)
    }
    
    
}
