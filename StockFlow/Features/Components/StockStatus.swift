//
//  StockStatus.swift
//  StockFlow
//
//  Created by Cicek on 03.10.26.
//

import SwiftUI

enum StockStatus {
    case inStock
    case lowStock
    case outOfStock

    func text(quantity: Int) -> String {
        switch self {
        case .inStock:
            return "\(quantity) in stock"
        case .lowStock:
            return "\(quantity) low"
        case .outOfStock:
            return "Out of stock"
        }
    }

    var color: Color {
        switch self {
        case .inStock:
            return Color(red: 0.09, green: 0.63, blue: 0.31)
        case .lowStock:
            return Color(red: 0.95, green: 0.60, blue: 0.05)
        case .outOfStock:
            return Color(red: 0.90, green: 0.15, blue: 0.15)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .inStock:
            return .green.opacity(0.10)
        case .lowStock:
            return .orange.opacity(0.10)
        case .outOfStock:
            return .red.opacity(0.10)
        }
    }
}

