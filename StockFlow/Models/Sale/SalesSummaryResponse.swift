//
//  SalesSummaryResponse.swift
//  StockFlow
//
//  Created by Cicek on 06.10.26.
//

import Foundation

struct SalesSummaryResponse: Decodable {
    let todaySales: Double
    let todayOrders: Int
    let totalSales: Double
    let totalOrders: Int

    enum CodingKeys: String, CodingKey {
        case todaySales = "today_sales"
        case todayOrders = "today_orders"
        case totalSales = "total_sales"
        case totalOrders = "total_orders"
    }
}
