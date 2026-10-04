//
//  ProductsViewState.swift
//  StockFlow
//
//  Created by Cicek on 29.09.26.
//
import Foundation

enum ProductsViewState {
    case idle
    case loading
    case loaded([ProductResponse])
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
