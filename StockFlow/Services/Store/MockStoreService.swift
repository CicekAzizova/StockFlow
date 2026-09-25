//
//  MockStoreService.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

final class MockStoreService: StoreService {

    func createStore(
        name: String,
        email: String,
        password: String,
        phone: String,
        storeName: String,
        storeAddress: String,
        storePhone: String
    ) async throws -> StoreResponse {

        return StoreResponse(
            id: 1,
            name: name,
            email: email,
            phone: phone,
            storeName: storeName,
            storeAddress: storeAddress,
            storePhone: storePhone,
            createdAt: "2026-09-23",
            token: "token"
        )
    }
}
