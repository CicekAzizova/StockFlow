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

    private let productStore: ProductsStore
    private let imageUploadService = ImageUploadService()
    private let tokenStorage: TokenStoring

    var state: AddProductViewState = .idle

    let product: ProductResponse?

    var name = ""
    var sku = ""
    var category = ""
    var description = ""
    var price = ""
    var discount = ""
    var costPrice = ""
    var quantity = ""
    var lowStockLimit = ""
    var imageUrls: [String]?

    var validationMessage: String?

    init(
        productStore: ProductsStore,
        product: ProductResponse? = nil,
        tokenStorage: TokenStoring
    ) {
        self.productStore = productStore
        self.product = product
        self.tokenStorage = tokenStorage

        guard let product else { return }

        name = product.name
        sku = product.sku
        category = product.category
        description = product.description
        price = String(product.price)
        discount = String(product.discount)
        costPrice = String(product.costPrice)
        quantity = String(product.quantity)
        lowStockLimit = String(product.lowStockLimit)
        imageUrls = product.imageUrls
    }

    private func makeProductRequest() -> ProductRequest? {
        guard validateFields() else {
            return nil
        }

        guard
            let price = price.asDecimal,
            let discount = discount.asDecimal,
            let costPrice = costPrice.asDecimal,
            let quantity = Int(quantity),
            let lowStockLimit = Int(lowStockLimit)
        else {
            validationMessage = "Please enter valid values."
            return nil
        }

        return ProductRequest(
            name: name,
            sku: sku,
            category: category,
            description: description,
            price: price,
            discount: discount,
            costPrice: costPrice,
            quantity: quantity,
            lowStockLimit: lowStockLimit,
            imageUrls: imageUrls
        )
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
            !$0.isBlank
        }) else {
            validationMessage = "Please fill in all fields."
            return false
        }

        return true
    }

    func saveProduct(images: [Data] = []) async {
        validationMessage = nil

        guard let initialRequest = makeProductRequest() else {
            return
        }

        state = .loading

        do {
            var uploadedUrls = imageUrls ?? []

            if !images.isEmpty {
                guard
                    let token = try tokenStorage.readToken(),
                    !token.isEmpty
                else {
                    throw ImageUploadError.missingToken
                }

                for imageData in images {
                    let imageUrl = try await imageUploadService.uploadImage(
                        imageData,
                        token: token
                    )

                    uploadedUrls.append(imageUrl)
                }
            }

            let request = ProductRequest(
                name: initialRequest.name,
                sku: initialRequest.sku,
                category: initialRequest.category,
                description: initialRequest.description,
                price: initialRequest.price,
                discount: initialRequest.discount,
                costPrice: initialRequest.costPrice,
                quantity: initialRequest.quantity,
                lowStockLimit: initialRequest.lowStockLimit,
                imageUrls: uploadedUrls
            )

            let response: ProductResponse

            if let product {
                response = try await productStore.saveProduct(
                    id: product.id,
                    request: request
                )
            } else {
                response = try await productStore.addProduct(request)
            }

            imageUrls = uploadedUrls
            state = .success(response)
            validationMessage = nil

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
