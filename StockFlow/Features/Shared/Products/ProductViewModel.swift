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
    private let defaults: UserDefaults
    
    private static let filterKey = "products.selectedFilter"
    
    var state: ProductsViewState = .idle
    
    var query: String = ""
    
    var loadMoreError: String?
    
    var selectedFilter: ProductStockFilter {
        didSet { defaults.set(selectedFilter.rawValue, forKey: Self.filterKey) }
    }
    
    init(productStore: ProductsStore, defaults: UserDefaults = .standard) {
        self.productStore = productStore
        self.defaults = defaults
        self.selectedFilter = defaults.string(forKey: Self.filterKey)
            .flatMap(ProductStockFilter.init(rawValue:)) ?? .all
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
