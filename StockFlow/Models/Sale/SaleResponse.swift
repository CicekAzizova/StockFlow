//
//  SaleResponse.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//

struct SaleResponse: Decodable {
    let id: Int
    let productId: Int
    let productName: String
    let quantity: Int
    let unitPrice: Double
    let totalPrice: Double
    let soldBy: Int
    let sellerName: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case productName = "product_name"
        case quantity
        case unitPrice = "unit_price"
        case totalPrice = "total_price"
        case soldBy = "sold_by"
        case sellerName = "seller_name"
        case createdAt = "created_at"
    }
}
