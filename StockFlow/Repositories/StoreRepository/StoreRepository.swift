//
//  StoreRepository.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

protocol StoreRepository {
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

final class DefaultStoreRepository: StoreRepository {
    private let storeService: StoreService
    private let tokenStorage: TokenStoring

    
    init(storeService: StoreService,tokenStorage: TokenStoring) {
        self.storeService = storeService
        self.tokenStorage = tokenStorage
    }
    
    func createStore(name: String, email: String, password: String, phone: String, storeName: String, storeAddress: String, storePhone: String) async throws -> StoreResponse {
        let response =  try await storeService.createStore(
            name: name,
            email: email,
            password: password,
            phone: phone,
            storeName: storeName,
            storeAddress: storeAddress,
            storePhone: storePhone
        )
        try saveToken(response.token)
        return response
    }
    
    func saveToken(_ token: String) throws {
        try tokenStorage.saveToken(token)
    }
}
