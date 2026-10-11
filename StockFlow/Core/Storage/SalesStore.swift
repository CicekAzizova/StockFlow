//
//  SalesStore.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//
import Foundation

@Observable
@MainActor

final class SalesStore {
    private let salesRepository: SalesRepository
    
    private var currentSalesPage = 1
    private var hasMoreSales = true
    var isLoadingMoreSales = false
    var isLoading: Bool = false
    var totalSales = 0

    var recentSales: [SaleResponse] = []
    
    var salesSummary: SalesSummaryResponse?
    
    init(salesRepository: SalesRepository) {
        self.salesRepository = salesRepository
    }
    //MARK: - Owner
    func loadRecentSales(limit: Int) async throws {
        isLoading = true
        currentSalesPage = 1
        hasMoreSales = true
        
        defer {
            isLoading = false
        }
        
        let response = try await salesRepository.getRecentSales(
                page: currentSalesPage,
                limit: limit
            )
            
            recentSales = response.items
            totalSales = response.total
            hasMoreSales = response.hasNext
            
    }
    
    func loadMoreSales(limit: Int) async throws {
        guard hasMoreSales else { return }
        guard !isLoadingMoreSales else { return }
        
        isLoadingMoreSales = true
        
        defer {
            isLoadingMoreSales = false
        }

            let nextPage = currentSalesPage + 1
            let response = try await salesRepository.getRecentSales(
                page: nextPage,
                limit: limit
            )
            
            recentSales.append(contentsOf: response.items)
            currentSalesPage = response.page
            hasMoreSales = response.hasNext
      
    }
    
    func refresh(limit: Int) async throws {
       try await loadRecentSales(limit: limit)
    }
    
    //MARK: - Seller
    
    func loadSalesSummary() async throws {
        salesSummary = try await salesRepository.getSalesSummary()
    }
}
