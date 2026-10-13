//
//  SalesEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 07.10.26.
//

import Foundation
enum SalesEndpoint: Endpoint {

    case summary
    case recentSales(page: Int,limit: Int)
    case createSale(CreateSaleRequest)

    var path: String {
        switch self {
        case .summary:
            "/sales/summary"
        case .recentSales, .createSale:
            "/sales"
        }
    }

    var method: HttpMethod {
        switch self {
        case .createSale:
            return .post
        case .summary, .recentSales:
            return .get
        }
    }

    var requiresAuthentication: Bool {
        true
    }

    var httpBody: (any Encodable)? {
        switch self {
        case .createSale(let request):
            return request
        case .summary, .recentSales:
            return nil
        }
    }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .summary, .createSale:
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
