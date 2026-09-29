//
//  CreateStoreViewModelTes.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//

import Testing
@testable import StockFlow

struct CreateStoreViewModelTests {
    @Test
    @MainActor
    
    func createSuccess() async {
        //Given
        
        let repository = MockStoreRepository(result: .success(
            StoreResponse(
                id: 1,
                name: "Owner",
                email: "owner@email.com",
                phone: "050",
                storeName: "xSpace",
                storeAddress: "Asdress",
                storePhone: "055",
                createdAt: "0",
                token: "token"
            )
        )
        )
        
        let viewModel = CreateStoreViewModel(storeRepository: repository)
        viewModel.name = "Owner"
        viewModel.email = "owner@email.com"
        viewModel.password = "123456"
        viewModel.phone = "0501234567"
        viewModel.storeName = "xSpace"
        viewModel.storeAddress = "Baku"
        viewModel.storePhone = "0551234567"
        
        // When
        await viewModel.createStore()
        
        // Then
        guard case .success(let store) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        
        #expect(store.id == 1)
        #expect(store.email == "owner@email.com")
        #expect(store.storeName == "xSpace")
    }
    
    @Test
    @MainActor
    func createStoreFailure() async {
        //Given
        let repository = MockStoreRepository(result: .failure(MockStoreError.responseError))
        
        let viewModel =  CreateStoreViewModel(storeRepository: repository)
        viewModel.name = "Owner"
        viewModel.email = "owner@email.com"
        viewModel.password = "123456"
        viewModel.phone = "0501234567"
        viewModel.storeName = "xSpace"
        viewModel.storeAddress = "Baku"
        viewModel.storePhone = "0551234567"
        
        //When
        await viewModel.createStore()
        
        //Then
        
        guard case .error(let error) = viewModel.state else {
            Issue.record("Expected error state")
            return
        }
        #expect(error.isEmpty == false)
    }
    
    @Test
    @MainActor
    func createStoreWithEmptyFieldsDoesNotCallRepository() async {
        //Given
        
        let repository = MockStoreRepository(result: .success(
            StoreResponse(
                id: 1,
                name: "Owner",
                email: "owner@email.com",
                phone: "050",
                storeName: "xSpace",
                storeAddress: "Asdress",
                storePhone: "055",
                createdAt: "0",
                token: "token"
            )
        )
        )
        
        let viewModel =  CreateStoreViewModel(storeRepository: repository)
        viewModel.name = ""
        viewModel.email = ""
        viewModel.password = ""
        viewModel.phone = ""
        viewModel.storeName = ""
        viewModel.storeAddress = ""
        viewModel.storePhone = ""
        
        // When
        await viewModel.createStore()
        
        // Then
        
        #expect(repository.createStoreCallCount == 0)
        
    }
    
    
}
