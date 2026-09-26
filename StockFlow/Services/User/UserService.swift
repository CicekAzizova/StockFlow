//
//  UserService.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import Foundation

protocol UserService {
    func getUser() async throws -> User
}

final class DefaultUserService: UserService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getUser() async throws -> User {
        let endpoint = UserEndpoint.getProfile
        return try await networkService.request(endpoint)
    }
}
