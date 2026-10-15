//
//  PaginationResponse.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//

import Foundation

struct PaginationResponse<T: Decodable>: Decodable {
    let items: [T]
    let page: Int
    let limit: Int
    let total: Int
    let hasNext: Bool

    enum CodingKeys: String, CodingKey {
        case items
        case page
        case limit
        case total
        case hasNext = "has_next"
    }
}
