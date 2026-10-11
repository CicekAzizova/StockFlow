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
    
    var isLoading: Bool = false
    
    // MARK: - Products Pagination
    private var currentProductPage = 1
    private var hasMoreProducts = true
    private var isLoadingMoreProducts = false
    var totalProducts = 0

    var products: [ProductResponse] = []
    var lowStockProducts: [ProductResponse] = []
    
    
    // MARK: - Low Stock Pagination
    
    private var currentLowStockPage = 1
    private var hasMoreLowStock = true
    private var isLoadingMoreLowStock = false
    var totalLowProducts = 0
    
    
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }

    // MARK: - Products
    
    func loadProducts(limit: Int) async throws {
        isLoading = true
        currentProductPage = 1
        hasMoreProducts = true
        
        defer {
            isLoading = false
        }
        let response = try await productRepository.getProducts(page: currentProductPage, limit: limit)
        
        products = response.items
        totalProducts = response.total
        hasMoreProducts = response.hasNext
    }
    
    func loadMoreProducts(limit: Int) async throws {
        guard hasMoreProducts else { return }
        guard !isLoadingMoreProducts else { return }
        
        isLoadingMoreProducts = true
        
        defer {
            isLoadingMoreProducts = false
        }
        
        let nextPage = currentProductPage + 1
        
        let response = try await productRepository.getProducts(page: nextPage, limit: limit)
        
        currentProductPage = response.page
        products.append(contentsOf: response.items)
        totalProducts = response.total
        hasMoreProducts = response.hasNext
    }
    
    // MARK: - Low Stock
    
    func loadLowStock(limit: Int) async throws {
        currentLowStockPage = 1
        hasMoreLowStock = true

      let response = try await productRepository.getLowStockProducts(page: currentLowStockPage, limit: limit)
        
        lowStockProducts = response.items
        totalLowProducts = response.total
        hasMoreLowStock = response.hasNext
    }
    
    func loadMoreLowStock(limit: Int) async throws {
        guard hasMoreLowStock else { return }
        guard !isLoadingMoreLowStock else { return }
        
        isLoadingMoreLowStock = true
        
        defer {
            isLoadingMoreLowStock = false
        }
        
        let nextPage = currentLowStockPage + 1
        
        let response = try await productRepository.getLowStockProducts(
            page: nextPage,
            limit: limit
        )
        lowStockProducts.append(contentsOf: response.items)
        
        currentLowStockPage = response.page
        totalLowProducts = response.total
        hasMoreLowStock = response.hasNext
    }

    func addProduct(_ request: ProductRequest) async throws -> ProductResponse {
        let response = try await productRepository.createProduct(request)
        try await loadProducts(limit: 5)
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
        totalProducts
    }

    var lowStockCount: Int {
        totalLowProducts
    }

    var totalQuantity: Int {
        products.reduce(0) {//toplama
            $0 + $1.quantity
        }
        
    }
}
