//
//  SalesRepository.swift
//  StockFlow
//
//  Created by Cicek on 07.10.26.
//

import Foundation

protocol SalesRepository {
    func getSalesSummary() async throws -> SalesSummaryResponse
    func getMySales() async throws -> [MySaleResponse]
    func getRecentSales(
            page: Int,
            limit: Int
        ) async throws -> PaginationResponse<SaleResponse>

}
final class DefaultSalesRepository: SalesRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    func getSalesSummary() async throws -> SalesSummaryResponse{
        return try await networkService.request(SalesEndpoint.summary)
    }
    func getMySales() async throws -> [MySaleResponse] {
        return try await networkService.request(SalesEndpoint.mySales)
    }
    
    func getRecentSales(page: Int, limit: Int) async throws -> PaginationResponse<SaleResponse> {
        try await networkService.request(SalesEndpoint.recentSales(page: page, limit: limit))
    }
}
