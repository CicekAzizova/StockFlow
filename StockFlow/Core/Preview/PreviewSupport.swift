//
//  PreviewSupport.swift
//  StockFlow
//
//  Created by Cicek on 16.10.26.
//

#if DEBUG
import Foundation

// MARK: - Sample data

enum PreviewError: LocalizedError {
    case failed
    var errorDescription: String? { "Could not load data. Please try again." }
}

enum PreviewData {

    static let owner = User(
        id: 1,
        email: "owner@stockflow.com",
        name: "Cicek",
        role: .owner,
        storeName: "Demo Store"
    )

    static let products: [ProductsResponse] = [
        product(id: 1, name: "Wireless Mouse", sku: "WM-1001", price: 24.99, discount: 10, quantity: 40),
        product(id: 2, name: "USB-C Cable", sku: "UC-2002", price: 9.99, quantity: 3),
        product(id: 3, name: "Mechanical Keyboard", sku: "MK-3003", price: 89.00, quantity: 0)
    ]

    static let sales: [SaleResponse] = [
        sale(id: 1, name: "Wireless Mouse", quantity: 2, unitPrice: 22.49),
        sale(id: 2, name: "USB-C Cable", quantity: 5, unitPrice: 9.99)
    ]

    static let summary = SalesSummaryResponse(
        todaySales: 94.93, todayOrders: 2, totalSales: 1250.50, totalOrders: 37
    )

    static func product(
        id: Int, name: String, sku: String, price: Double,
        discount: Double = 0, quantity: Int, lowStockLimit: Int = 5
    ) -> ProductsResponse {
        ProductsResponse(
            id: id, name: name, sku: sku, category: "Electronics",
            description: "Sample product", price: price, discount: discount,
            costPrice: price / 2, quantity: quantity, lowStockLimit: lowStockLimit,
            imageUrls: nil, createdAt: "2026-10-01"
        )
    }

    static func sale(id: Int, name: String, quantity: Int, unitPrice: Double) -> SaleResponse {
        SaleResponse(
            id: id, productId: id, productName: name, quantity: quantity,
            unitPrice: unitPrice, totalPrice: unitPrice * Double(quantity),
            soldBy: 2, sellerName: "Seller", createdAt: .now
        )
    }

    static func page<T: Decodable>(_ items: [T]) -> PaginationResponse<T> {
        PaginationResponse(items: items, page: 1, limit: 10, total: items.count, hasNext: false)
    }
}

// MARK: - Preview repositories

/// `result` nəticəni, `delay` isə uzun yüklənmə (Loading) halını simulyasiya edir.
struct PreviewProductRepository: ProductRepository {
    var result: Result<[ProductsResponse], Error> = .success(PreviewData.products)
    var delay: Duration?

    private func items() async throws -> [ProductsResponse] {
        if let delay { try await Task.sleep(for: delay) }
        return try result.get()
    }

    func getProducts(page: Int, limit: Int) async throws -> PaginationResponse<ProductsResponse> {
        PreviewData.page(try await items())
    }

    func getLowStockProducts(page: Int, limit: Int) async throws -> PaginationResponse<ProductsResponse> {
        PreviewData.page(try await items().filter { $0.stockStatus != .inStock })
    }

    func createProduct(_ request: ProductRequest) async throws -> ProductsResponse { throw PreviewError.failed }
    func getProduct(bySku sku: String) async throws -> ProductsResponse { throw PreviewError.failed }
    func updateProduct(id: Int, request: ProductRequest) async throws -> ProductsResponse { throw PreviewError.failed }
    func deleteProduct(id: Int) async throws {}
}

struct PreviewSalesRepository: SalesRepository {
    var fails = false

    func getSalesSummary() async throws -> SalesSummaryResponse {
        if fails { throw PreviewError.failed }
        return PreviewData.summary
    }

    func getRecentSales(page: Int, limit: Int) async throws -> PaginationResponse<SaleResponse> {
        if fails { throw PreviewError.failed }
        return PreviewData.page(PreviewData.sales)
    }

    func getSales(sellerId: Int, page: Int, limit: Int) async throws -> PaginationResponse<SaleResponse> {
        if fails { throw PreviewError.failed }
        return PreviewData.page(PreviewData.sales)
    }

    func createSale(_ request: CreateSaleRequest) async throws -> CreateSaleResponse {
        throw PreviewError.failed
    }
}
#endif
