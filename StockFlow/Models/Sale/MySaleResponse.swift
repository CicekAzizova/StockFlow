//
//  MySaleResponse.swift
//  StockFlow
//
//  Created by Cicek on 07.10.26.
//

struct MySaleResponse: Decodable {
    let id: Int
    let productId: Int
    let productName: String
    let quantity: Int
    let unitPrice: Double
    let totalPrice: Double
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case productName = "product_name"
        case quantity
        case unitPrice = "unit_price"
        case totalPrice = "total_price"
        case createdAt = "created_at"
    }
}
