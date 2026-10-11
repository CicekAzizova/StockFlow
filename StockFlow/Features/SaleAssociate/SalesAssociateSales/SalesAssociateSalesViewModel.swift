//
//  SalesAssociateSalesViewModel.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

import Foundation

@Observable
@MainActor

final class SalesAssociateSalesViewModel {
    private let salesStore: SalesStore
    
    var state: SalesViewState = .idle
    
    init(salesStore: SalesStore) {
        self.salesStore = salesStore
    }
    
    func loadSales() async {
        let previousState = state
        state = .loading
        
        do {
            try await salesStore.loadSalesSummary()
            try await salesStore.loadRecentSales(limit: 10)
            state = .loaded
            
        } catch is CancellationError {
            state = previousState
        }catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func refresh() async {
        await loadSales()
    }
    
    var todaySales: Double {
        salesStore.salesSummary?.todaySales ?? 0
    }
    
    var totalOrders: Int {
        salesStore.salesSummary?.totalOrders ?? 0
    }
    
    var recentSales: [SaleResponse] {
        salesStore.recentSales
    }
}
