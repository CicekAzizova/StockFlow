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

    init(productStore: ProductsStore) {
        self.productStore = productStore
    }

    func loadProducts() async {
        state = .loading

        do {
            try await productStore.loadLowStock(limit: 10)
            state = .loaded
        } catch is CancellationError {
            return
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func refresh() async {
        await loadProducts()
    }

    func loadMoreProducts() async {
        do {
            try await productStore.loadMoreLowStock()
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    var products: [ProductResponse] {
        productStore.lowStockProducts
    }

    var totalCount: Int {
        productStore.totalLowProducts
    }
}
