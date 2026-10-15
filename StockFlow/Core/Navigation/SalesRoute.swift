//
//  SalesRoute.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

enum SalesRoute: Hashable {
    case scanner
    case history
    case detail(SaleResponse)
}
