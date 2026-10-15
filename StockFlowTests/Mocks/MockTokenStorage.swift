//
//  MockTokenStorage.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Foundation
@testable import StockFlow

@MainActor
final class MockTokenStorage: TokenStoring {
    var token: String?

    func saveToken(_ token: String) throws { self.token = token }
    func readToken() throws -> String? { token }
    func deleteToken() throws { token = nil }
}
