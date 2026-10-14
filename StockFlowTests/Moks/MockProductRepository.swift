//
//  MockProductRepository.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Foundation
@testable import StockFlow

@MainActor
final class MockProductRepository: ProductRepository {
    var productsResult: Result<PaginationResponse<ProductsResponse>, Error> = .success(TestData.page([]))
    var lowStockResult: Result<PaginationResponse<ProductsResponse>, Error> = .success(TestData.page([]))
    var singleProductResult: Result<ProductsResponse, Error> = .failure(TestError.failed)
    var deleteResult: Result<Void, Error> = .success(())

    private(set) var requestedSkus: [String] = []

    func createProduct(_ request: ProductRequest) async throws -> ProductsResponse {
        try singleProductResult.get()
    }

    func getProducts(page: Int, limit: Int) async throws -> PaginationResponse<ProductsResponse> {
        try productsResult.get()
    }

    func getProduct(bySku sku: String) async throws -> ProductsResponse {
        requestedSkus.append(sku)
        return try singleProductResult.get()
    }

    func updateProduct(id: Int, request: ProductRequest) async throws -> ProductsResponse {
        try singleProductResult.get()
    }

    func deleteProduct(id: Int) async throws {
        try deleteResult.get()
    }

    func getLowStockProducts(page: Int, limit: Int) async throws -> PaginationResponse<ProductsResponse> {
        try lowStockResult.get()
    }
}
