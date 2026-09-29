//  MockAuthService.swift
//  StockFlow
//
//  Created by Cicek on 22.09.26.
//

import Foundation

enum MockAuthError: LocalizedError {

    case invalidCredentials

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Email and password incorrect."
        }
    }
}

final class MockAuthService: AuthService {

    func login(
        email: String,
        password: String
    ) async throws -> LoginResponse {

        guard email == "owner@stockflow.com",
              password == "123456" else {
            throw MockAuthError.invalidCredentials
        }

        let user = User(
            id: 1,
            email: "aruz@gmail.com",
            name: "Aruz",
            role: .owner,
            storeName: "Mobil"
        )

        return LoginResponse(
            user: user,
            token: "mock_token_123"
        )
    }
}




