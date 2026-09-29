//
//  ProductsRequest.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import Foundation

struct ProductRequest: Encodable {
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
    
    enum CodingKeys: String, CodingKey {
        case name, sku, category,description, price, discount, quantity
        case costPrice = "cost_price"
        case lowStockLimit = "low_stock_limit"
        case imageUrl = "image_url"
    }
}
