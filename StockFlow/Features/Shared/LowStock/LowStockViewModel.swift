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
    
    var products: [ProductsResponse] {
        productStore.lowStockProducts
    }

    init(productStore: ProductsStore) {
        self.productStore = productStore
    }
    
    func loadProductsIfNeeded() async {
        guard !state.isLoaded else { return }
        await loadProducts()
    }
    
    func loadProducts() async {
        let previousState = state
        if !state.isLoaded { state = .loading }

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
}
