//
//  ProductsStore.swift
//  StockFlow
//
//  Created by Cicek on 30.09.26.
//
import Foundation
import Observation

@Observable
@MainActor
final class ProductsStore {

    private let productRepository: ProductRepository

    var products: [ProductResponse] = []
    var isLoading = false
    var errorMessage: String?
    

    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }


    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        do {
            products = try await productRepository.getProducts()
        }
        catch {
            errorMessage = error.localizedDescription
        }
    }

    func addProduct(_ request: ProductRequest) async throws -> ProductResponse {
        let response = try await productRepository.createProduct(request)
        await loadProducts()
        return response
    }
    
    func saveProduct(id: Int, request: ProductRequest) async throws -> ProductResponse {
        let response = try await productRepository.updateProduct(id: id, request: request)
        if let index = products.firstIndex(where: { $0.id == id }) {
            products[index] = response
        }
        return response
    }
    
    func deleteProduct(id: Int) async throws {
        try await productRepository.deleteProduct(id: id)
        
        products.removeAll { $0.id == id }
        
    }

    // MARK: - Computed Properties

    var productsCount: Int {
        products.count
    }

    var lowStockProducts: [ProductResponse] {
        products.filter {
            $0.quantity <= $0.lowStockLimit
        }
    }

    var lowStockCount: Int {
        lowStockProducts.count
    }

    var totalQuantity: Int {
        products.reduce(0) {//toplama
            $0 + $1.quantity
        }
    }
}
