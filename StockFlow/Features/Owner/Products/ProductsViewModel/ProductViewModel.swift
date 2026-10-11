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
    
    var selectedFilter: ProductStockFilter = .all
    
    init(productStore: ProductsStore) {
        self.productStore = productStore
    }
    var allProducts: [ProductResponse] {
        productStore.products
    }
    var productsCount: Int {
        productStore.productsCount
    }
    
    var lowStockProducts: [ProductResponse] {
        productStore.lowStockProducts
    }
    var isLowStock: (ProductResponse) -> Bool {
        { product in
            product.quantity <= product.lowStockLimit
        }
    }
    
    var filteredProducts: [ProductResponse] {
        
        let stockFilteredProducts: [ProductResponse]
        
            switch selectedFilter {
            case .all:
                stockFilteredProducts = allProducts
            case .inStock:
                stockFilteredProducts = allProducts.filter { $0.quantity > $0.lowStockLimit }
            case .lowStock:
                stockFilteredProducts = lowStockProducts
            case .outStock:
                stockFilteredProducts = allProducts.filter{ $0.quantity == 0 }
            }
            guard !query.isEmpty else {
                return stockFilteredProducts
            }
            return stockFilteredProducts.filter {
                $0.name.localizedCaseInsensitiveContains(query)
            }
        
    }
    
    func loadProducts() async {
        state = .loading
        do {
            try await productStore.loadProducts(limit: 10)
            state = .loaded(allProducts)
        }
        catch {
            state = .error(error.localizedDescription)
        }
    }
    
    func refresh() async {
       await loadProducts()
    }
    
    func loadMoreProducts() async {
        do {
            try await productStore.loadMoreProducts(limit: 10)
            state = .loaded(allProducts)
        }
        catch {
            state = .error(error.localizedDescription)
        }
    }
}
