//
//  OwnerDashboardViewModel.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//

import Foundation

@Observable
@MainActor

final class OwnerDashboardViewModel {
    
    let productStore: ProductsStore
    
    var state: OwnerDashboardViewState = .idle
    
    init(productStore: ProductsStore) {
        self.productStore = productStore
    }
    
    func loadDashboard() async {
        state = .loading
        await productStore.loadProducts()
        if let errorMessage = productStore.errorMessage {
            state = .error(errorMessage)
            return
        }
        state = .loaded
    }
    
    func loadProducts() {
        
    }
    
    func loadSales() {
        
    }
    
    func loadInventorySummary() {
        
    }
    
    func loadSalesSummary() {
        
    }
    
    func loadLowStockProducts() {
        
    }
    
    func refresh() async {
        await loadDashboard()
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

}
