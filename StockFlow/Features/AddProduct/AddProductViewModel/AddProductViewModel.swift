//
//  AddProductsViewModel.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import Foundation

@Observable
@MainActor
final class AddProductViewModel {
    
    private let productRepository: ProductRepository
    
    var state: AddProductViewState = .idle
    
    var name = ""
    var sku = ""
    var category = ""
    var description = ""
    var price = ""
    var discount = ""
    var costPrice = ""
    var quantity = ""
    var lowStockLimit = ""
    var imageUrl: String?
    
    var validationMessage: String?
        
    init(productRepository: ProductRepository) {
        self.productRepository = productRepository
    }
    
    func createProduct() async {
        validationMessage = nil
        
        guard validateFields() else { return }
        
        guard let price = Double(price),
              let discount = Double(discount),
              let costPrice = Double(costPrice),
              let quantity = Int(quantity),
              let lowStockLimit = Int(lowStockLimit) else {
            validationMessage = "Please enter valid values."
            return
        }
        
        let request = ProductRequest(
            name: name,
            sku: sku,
            category: category,
            description: description,
            price: price,
            discount: discount,
            costPrice: costPrice,
            quantity: quantity,
            lowStockLimit: lowStockLimit,
            imageUrl: imageUrl
        )
        
        state = .loading
        
        do {
            let result = try await productRepository.createProduct(request)
            state = .success(result)
            validationMessage = nil
        } catch {
            print("❌ CREATE PRODUCT ERROR:", error)
            print("❌ DESCRIPTION:", error.localizedDescription)

            state = .error(error.localizedDescription)
        }
    }
    
    func validateFields() -> Bool {
        let fields = [
                    name,
                    sku,
                    category,
                    description,
                    price,
                    discount,
                    costPrice,
                    quantity,
                    lowStockLimit
                ]
        guard fields.allSatisfy({
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }) else {
            validationMessage = "Please fill in all fields."
            return false
            }
        return true
    }
}
