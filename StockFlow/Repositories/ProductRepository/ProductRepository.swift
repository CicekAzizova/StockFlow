//
//  ProductsRepository.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//
import Foundation

protocol ProductRepository {
    func createProduct(_ request: ProductRequest) async throws -> ProductResponse
    func getProducts() async throws -> [ProductResponse]
    func searchProducts(_ query: String) async throws -> [ProductResponse]
    func updateProduct(id: Int, request: ProductRequest) async throws -> ProductResponse
    func deleteProduct(id: Int) async throws
}

final class DefaultProductRepository: ProductRepository {
  
    private let productService: ProductService
    
    init(productService: ProductService) {
        self.productService = productService
    }
    
    func createProduct(_ request: ProductRequest) async throws -> ProductResponse {
        try await productService.createProduct(request)
    }
    
    func getProducts() async throws -> [ProductResponse] {
        try await productService.getProducts()
    }
    
    func searchProducts(_ query: String) async throws -> [ProductResponse] {
        try await productService.searchProducts(query)
       
    }
    
    func updateProduct(id: Int, request: ProductRequest) async throws -> ProductResponse {
        try await productService.updateProduct(id: id, request: request)
    }
    
    func deleteProduct(id: Int) async throws  {
        try await productService.deleteProduct(id: id)
    }
}
