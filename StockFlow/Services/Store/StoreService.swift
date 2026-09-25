//
//  StoreService.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

protocol StoreService {
    
    func createStore(
        name: String,
        email: String,
        password: String,
        phone: String,
        storeName: String,
        storeAddress: String,
        storePhone: String
    ) async throws -> StoreResponse
    
}

final class DefaultStoreService: StoreService {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func createStore(name: String, email: String, password: String, phone: String, storeName: String, storeAddress: String, storePhone: String) async throws -> StoreResponse {
        let endpoint = StoreEndpoint.createStore(name: name, email: email, password: password, phone: phone, storeName: storeName, storeAddress: storeAddress, storePhone: storePhone)
        return try await networkService.request(endpoint)
    }
}
