//
//  ProductDetailViewModel.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//

import Foundation

@Observable
@MainActor

final class ProductDetailViewModel {
    
    private let productStore: ProductsStore
    private let initialProduct: ProductsResponse
    
    var product: ProductsResponse {
        productStore.product(withID: initialProduct.id) ?? initialProduct
    }
    
    var state: ProductDetailViewState = .idle

    init(productStore: ProductsStore, product: ProductsResponse) {
        self.productStore = productStore
        self.initialProduct = product
        
        
    }
    
    func deleteProduct() async {
        state = .deleting
        do {
            try await productStore.deleteProduct(id: product.id)
            state = .deleted
        }
        catch {
            state = .error(error.localizedDescription)
        }
    }
}
