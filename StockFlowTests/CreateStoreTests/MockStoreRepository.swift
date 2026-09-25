//
//  MockStoreRepository.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//

import Foundation
@testable import StockFlow

enum MockStoreError: Error {
    case responseError
}

final class MockStoreRepository : StoreRepository {
    
    let result: Result<StoreResponse, Error>
    
    private(set) var createStoreCallCount = 0
    
    init(result: Result<StoreResponse, Error>) {
        self.result = result
    }
    
    func createStore(name: String, email: String, password: String, phone: String, storeName: String, storeAddress: String, storePhone: String) async throws -> StockFlow.StoreResponse {
        
        createStoreCallCount += 1
        
        return try result.get()
    }
    
    
}
