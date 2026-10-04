//
//  MockProductService.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//

import Foundation

final class MockProductService: ProductService {

    var products: [ProductResponse] = []
    var shouldThrowError = false

    private var nextProductID = 1

    func createProduct(_ request: ProductRequest) async throws -> ProductResponse {
        if shouldThrowError {
            throw MockError.operationFailed
        }

        let product = ProductResponse(
            id: nextProductID,
            name: request.name,
            sku: request.sku,
            category: request.category,
            description: request.description,
            price: request.price,
            discount: request.discount,
            costPrice: request.costPrice,
            quantity: request.quantity,
            lowStockLimit: request.lowStockLimit,
            imageUrls: request.imageUrls,
            createdAt: ""
        )

        nextProductID += 1
        products.append(product)

        return product
    }

    func getProducts() async throws -> [ProductResponse] {
        if shouldThrowError {
            throw MockError.operationFailed
        }

        return products
    }

    func searchProducts(_ query: String) async throws -> [ProductResponse] {
        if shouldThrowError {
            throw MockError.operationFailed
        }

        return products.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }

    func updateProduct(
        id: Int,
        request: ProductRequest
    ) async throws -> ProductResponse {
        if shouldThrowError {
            throw MockError.operationFailed
        }

        guard let index = products.firstIndex(where: { $0.id == id }) else {
            throw MockError.productNotFound
        }

        let updatedProduct = ProductResponse(
            id: id,
            name: request.name,
            sku: request.sku,
            category: request.category,
            description: request.description,
            price: request.price,
            discount: request.discount,
            costPrice: request.costPrice,
            quantity: request.quantity,
            lowStockLimit: request.lowStockLimit,
            imageUrls: request.imageUrls,
            createdAt: products[index].createdAt
        )

        products[index] = updatedProduct

        return updatedProduct
    }

    func deleteProduct(id: Int) async throws {
        if shouldThrowError {
            throw MockError.operationFailed
        }

        guard let index = products.firstIndex(where: { $0.id == id }) else {
            throw MockError.productNotFound
        }

        products.remove(at: index)
    }
}

enum MockError: Error {
    case operationFailed
    case productNotFound
}
