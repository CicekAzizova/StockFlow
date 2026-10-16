//
//  ProductViewModelTests.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Testing
@testable import StockFlow
import Foundation

@MainActor
struct ProductViewModelTests {

    private let inStock = TestData.product(id: 1, name: "Apple", quantity: 20, lowStockLimit: 5)
    private let lowStock = TestData.product(id: 2, name: "Banana", quantity: 3, lowStockLimit: 5)
    private let outOfStock = TestData.product(id: 3, name: "Cherry", quantity: 0, lowStockLimit: 5)

    private func makeSUT(
        result: Result<PaginationResponse<ProductsResponse>, Error>,
        defaults: UserDefaults = UserDefaults(suiteName: UUID().uuidString) ?? .standard
    ) -> ProductViewModel {
        let repository = MockProductRepository()
        repository.productsResult = result
        let store = ProductsStore(productRepository: repository)
        return ProductViewModel(productStore: store, defaults: defaults)
    }

    @Test func loadProductsSucceeds() async {
        let sut = makeSUT(result: .success(TestData.page([inStock, lowStock, outOfStock])))

        await sut.loadProducts()

        guard case .loaded(let products) = sut.state else {
            Issue.record("Expected .loaded state")
            return
        }
        #expect(products.count == 3)
        #expect(sut.allProducts.count == 3)
    }

    @Test func loadProductsFailureShowsError() async {
        let sut = makeSUT(result: .failure(TestError.failed))

        await sut.loadProducts()

        guard case .error(let message) = sut.state else {
            Issue.record("Expected .error state")
            return
        }
        #expect(message == "Test failure")
    }

    @Test func lowStockFilterReturnsOnlyLowStockProducts() async {
        let sut = makeSUT(result: .success(TestData.page([inStock, lowStock, outOfStock])))
        await sut.loadProducts()

        sut.selectedFilter = .lowStock

        #expect(sut.filteredProducts.map(\.id) == [2])
    }

    @Test func outOfStockFilterReturnsOnlyEmptyProducts() async {
        let sut = makeSUT(result: .success(TestData.page([inStock, lowStock, outOfStock])))
        await sut.loadProducts()

        sut.selectedFilter = .outStock

        #expect(sut.filteredProducts.map(\.id) == [3])
    }

    @Test func searchIsCaseInsensitive() async {
        let sut = makeSUT(result: .success(TestData.page([inStock, lowStock, outOfStock])))
        await sut.loadProducts()

        sut.query = "bAN"

        #expect(sut.filteredProducts.map(\.name) == ["Banana"])
    }
    
    @Test func selectedFilterIsRestoredFromDefaults() {
        let defaults = UserDefaults(suiteName: UUID().uuidString) ?? .standard
        
        let first = makeSUT(result: .success(TestData.page([])), defaults: defaults)
        first.selectedFilter = .lowStock
        
        let second = makeSUT(result: .success(TestData.page([])), defaults: defaults)
        #expect(second.selectedFilter == .lowStock)
    }
}
