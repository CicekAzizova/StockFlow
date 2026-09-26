//
//  MockUserService.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import Foundation

final class MockUserService: UserService {

    func getUser() async throws -> User {
        User(
            id: 1,
            email: "cicek.azizova@gmail.com",
            firstName: "Cicek",
            lastName: "Azizova",
            role: .owner,
            storeId: 1
        )
    }
}
