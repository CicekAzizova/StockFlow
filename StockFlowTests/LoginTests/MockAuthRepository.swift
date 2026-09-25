//
//  MockAuthRepository.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation
@testable import StockFlow

final class MockAuthRepository: AuthRepository {
    
    let result: Result<LoginResponse, Error>
    
    init(result: Result<LoginResponse, Error>) {
        self.result = result
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        try result.get()
    }
}
