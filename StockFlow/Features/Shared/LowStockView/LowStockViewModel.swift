//
//  LowStockViewModel.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

import Foundation

@Observable
@MainActor

final class LowStockViewModel {
    
    private let productStore: ProductsStore

    var state: LowStockViewState = .idle
    
    var loadMoreError: String?

    init(productStore: ProductsStore) {
        self.productStore = productStore
    }

    func loadProducts() async {
        let previousState = state
        state = .loading

        do {
            try await productStore.loadLowStock(limit: 10)
            state = .loaded
        } catch is CancellationError {
            state = previousState
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func refresh() async {
        await loadProducts()
    }

    func loadMoreProducts() async {
        loadMoreError = nil
        do {
            try await productStore.loadMoreLowStock()
        }
        catch is CancellationError {
            return
        }
        catch {
            loadMoreError = error.localizedDescription
        }
    }

    var products: [ProductsResponse] {
        productStore.lowStockProducts
    }

    var totalCount: Int {
        productStore.totalLowProducts
    }
}
