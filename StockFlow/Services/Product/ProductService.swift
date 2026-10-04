//
//  AddProductService.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import Foundation

protocol ProductService {
    func createProduct(_ request: ProductRequest) async throws -> ProductResponse
    func getProducts() async throws -> [ProductResponse]
    func searchProducts(_ query: String) async throws -> [ProductResponse]
    func updateProduct(id: Int, request: ProductRequest) async throws -> ProductResponse
    func deleteProduct(id: Int) async throws
}


final class DefaultProductService: ProductService {
  
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func createProduct(_ request: ProductRequest) async throws -> ProductResponse {
        try await networkService.request(ProductsEndpoint.createProduct(request))
    }
    
    func getProducts() async throws -> [ProductResponse] {
        try await networkService.request(ProductsEndpoint.getProducts)
    }
    
    func searchProducts(_ query: String) async throws -> [ProductResponse] {
        try await networkService.request(ProductsEndpoint.search(query: query))
    }
    
    func updateProduct(id: Int, request: ProductRequest) async throws -> ProductResponse {
        try await networkService.request(ProductsEndpoint.editProduct(id: id, request: request))
    }
    
    func deleteProduct(id: Int) async throws  {
        try await networkService.requestVoid(ProductsEndpoint.deleteProduct(id: id))
    }
}

