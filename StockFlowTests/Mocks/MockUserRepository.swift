//
//  MockUserRepository.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Foundation
@testable import StockFlow

@MainActor
final class MockUserRepository: UserRepository {
    var result: Result<User, Error> = .success(TestData.owner)

    func getUser() async throws -> User {
        try result.get()
    }
}
