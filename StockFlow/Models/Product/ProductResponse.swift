//
//  ProductsResponse.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import Foundation

struct ProductResponse: Decodable {
    let id: Int
    let name: String
    let sku: String
    let category:String
    let description: String
    let price: Double
    let discount: Double
    let costPrice: Double
    let quantity: Int
    let lowStockLimit: Int
    let imageUrl: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, sku, category,description, price, discount, quantity
        case costPrice = "cost_price"
        case lowStockLimit = "low_stock_limit"
        case createdAt = "created_at"
        case imageUrl = "image_url"
    }
}
