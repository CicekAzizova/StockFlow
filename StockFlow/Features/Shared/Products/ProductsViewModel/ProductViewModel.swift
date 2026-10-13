//
//  ProductViewModel.swift
//  StockFlow
//
//  Created by Cicek on 28.09.26.
//
import Foundation

@Observable
@MainActor
final class ProductViewModel {
    
    private let productStore: ProductsStore
    
    var state: ProductsViewState = .idle
    
    var query: String = ""
    
    var loadMoreError: String?
    
    var selectedFilter: ProductStockFilter = .all
    
    init(productStore: ProductsStore) {
        self.productStore = productStore
    }
    var allProducts: [ProductsResponse] {
        productStore.products
    }
    var productsCount: Int {
        productStore.productsCount
    }
    
    var filteredProducts: [ProductsResponse] {
        
        let stockFilteredProducts: [ProductsResponse]
        
            switch selectedFilter {
            case .all:
                stockFilteredProducts = allProducts
            case .inStock:
                stockFilteredProducts = allProducts.filter { $0.stockStatus == .inStock }
            case .lowStock:
                stockFilteredProducts = allProducts.filter { $0.stockStatus == .lowStock }
            case .outStock:
                stockFilteredProducts = allProducts.filter{ $0.stockStatus == .outOfStock }
            }
            guard !query.isEmpty else {
                return stockFilteredProducts
            }
            return stockFilteredProducts.filter {
                $0.name.localizedCaseInsensitiveContains(query)
            }
        
    }
    
    func loadProducts() async {
        let previousState = state
        
        if !state.isLoaded {
            state = .loading
        }
        do {
            try await productStore.loadProducts(limit: 10)
            state = .loaded(allProducts)
        }
        catch is CancellationError {
            state = previousState
        }
        catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func refresh() async {
       await loadProducts()
    }
    
    func loadMoreProducts() async {
        loadMoreError = nil
        do {
            try await productStore.loadMoreProducts()
            state = .loaded(allProducts)
        }catch is CancellationError {
            return
        }
        catch {
            loadMoreError = error.localizedDescription
        }
    }
    
    func loadProductsIfNeeded() async {
        guard case .idle = state else { return }
        await loadProducts()
    }
}
