//
//  CreateSaleRequest.swift
//  StockFlow
//
//  Created by Cicek on 12.10.26.
//

import Foundation

struct CreateSaleRequest: Encodable {
    let productId: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case quantity
    }
}
