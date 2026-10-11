//
//  SalesEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 07.10.26.
//

import Foundation
enum SalesEndpoint: Endpoint {

    case summary
    case mySales
    case recentSales(page: Int,limit: Int)

    var path: String {
        switch self {
        case .summary:
            "/sales/summary"
        case .mySales:
            "/sales/my-sales"
        case .recentSales:
            "/sales"
        }
    }

    var method: HttpMethod {
        .get
    }

    var requiresAuthentication: Bool {
        true
    }

    var httpBody: (any Encodable)? {
        nil
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .summary,
                .mySales:
            nil
            
        case .recentSales(let page, let limit):
            [
                URLQueryItem(
                    name: "page",
                    value: String(page)
                ),
                URLQueryItem(
                    name: "limit",
                    value: String(limit)
                )
            ]
        }
    }
}
