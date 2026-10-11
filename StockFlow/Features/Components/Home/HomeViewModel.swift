//
//  HomeViewModel.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//

import Foundation

@Observable
@MainActor

final class HomeViewModel {
    
    private let productStore: ProductsStore
    private let salesStore: SalesStore
    
    var state: HomeViewState = .idle
    
    init(productStore: ProductsStore,
         salesStore: SalesStore
    ) {
        self.productStore = productStore
        self.salesStore = salesStore
    }
    
    func loadHome() async {
        state = .loading
        do   {
            async let loadProducts: () = loadProducts()
            async let loadLowStock: () = loadLowStock()
            async let loadRecentSales: () = loadRecentSales()
            async let loadSalesSummary: () = loadSalesSummary()
            
            _ = try await (
                loadProducts,
                loadLowStock,
                loadRecentSales,
                loadSalesSummary
            )
            
            state = .loaded
        }
        catch is CancellationError {
            return
        }
        catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func loadProducts() async throws {
        try await productStore.loadProducts(limit: 5)
    }
    
    func loadLowStock() async throws {
        try await productStore.loadLowStock(limit: 5)
    }
    
    func loadRecentSales() async throws {
       try await salesStore.loadRecentSales(limit: 5)
    }
    
    func loadSalesSummary() async throws {
        try await salesStore.loadSalesSummary()
    }
   
    func refresh() async {
        await loadHome()
    }
    
    var productsCount: Int {
        productStore.productsCount
    }
    
    var totalQuantity: Int {
        productStore.totalQuantity
    }
    
    var lowStockCount: Int {
        productStore.lowStockCount
    }
    
    var lowStockProducts: [ProductResponse] {
        productStore.lowStockProducts
    }
    
    var recentSales: [SaleResponse] {
        salesStore.recentSales
    }
    
    var revenue: Double {
        salesStore.salesSummary?.totalSales ?? 0
    }
    
    var todaySales: Double {
        salesStore.salesSummary?.todaySales ?? 0
    }
    
    var totalOrders: Int {
        salesStore.salesSummary?.totalOrders ?? 0
    }
}
