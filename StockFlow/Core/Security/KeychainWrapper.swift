//
//  KeychainWrapper.swift
//  StockFlow
//
//  Created by Cicek on 21.09.26.
//
import Foundation

protocol TokenStoring {
    func saveToken(_ token: String) throws
    func readToken() throws -> String?
    func deleteToken() throws
}

final class KeychainWrapper: TokenStoring {
    
    private let service: KeychainService
    
    init(service: KeychainService = KeychainService()){
        self.service = service
    }
    
    private enum Keys {
        static let authToken = "auth_token"
    }
    
    func saveToken(_ token: String) throws {
        guard let data = token.data(using: .utf8) else { throw
            KeychainServiceError.invalidData
        }
        try service.save(data, for: Keys.authToken)
    }
    
    func readToken() throws -> String? {
        guard let data = try service.read(for: Keys.authToken) else { return nil }
        guard let token = String(data: data, encoding: .utf8) else { throw KeychainServiceError.invalidData}
        return token
    }
    
    func deleteToken() throws {
        try service.delete(for: Keys.authToken)
    }
}
