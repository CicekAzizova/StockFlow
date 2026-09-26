//
//  UserRepository.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import Foundation

protocol UserRepository {
    func getUser() async throws -> User
    func deleteToken() throws
}

final class DefaultUserRepository: UserRepository {
    
    private let userService: UserService
    private let tokenStorage: TokenStoring

    init(userService: UserService, tokenStorage: TokenStoring) {
        self.userService = userService
        self.tokenStorage = tokenStorage
    }
    
    func getUser() async throws -> User {
        try await userService.getUser()
    }
    
    func deleteToken() throws {
       try tokenStorage.deleteToken()
    }
}
