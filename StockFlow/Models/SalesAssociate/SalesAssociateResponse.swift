//
//  SalesAssociateResponse.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

import Foundation

struct SalesAssociateResponse: Decodable {
    let id: Int
    let name: String
    let surname: String
    let fin: String
    let email: String
    let phone: String
    let role: String
    let storeId: Int
    let createdAt: String
    let todaySales: Double
    let totalSalesThisMonth: Double

    enum CodingKeys: String, CodingKey {
        case id, name, surname, fin, email, phone, role
        case storeId = "store_id"
        case createdAt = "created_at"
        case todaySales = "today_sales"
        case totalSalesThisMonth = "total_sales_this_month"
    }
}
