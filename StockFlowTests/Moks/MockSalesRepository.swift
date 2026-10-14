//
//  MockSalesRepository.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Foundation
@testable import StockFlow

@MainActor
final class MockSalesRepository: SalesRepository {
    var createSaleResult: Result<CreateSaleResponse, Error> = .success(TestData.createSaleResponse(total: 0))
    private(set) var createSaleRequests: [CreateSaleRequest] = []

    func getSalesSummary() async throws -> SalesSummaryResponse {
        SalesSummaryResponse(todaySales: 0, todayOrders: 0, totalSales: 0, totalOrders: 0)
    }

    func getRecentSales(page: Int, limit: Int) async throws -> PaginationResponse<SaleResponse> {
        TestData.page([])
    }

    func createSale(_ request: CreateSaleRequest) async throws -> CreateSaleResponse {
        createSaleRequests.append(request)
        return try createSaleResult.get()
    }

    func getSales(sellerId: Int, page: Int, limit: Int) async throws -> PaginationResponse<SaleResponse> {
        TestData.page([])
    }
}
