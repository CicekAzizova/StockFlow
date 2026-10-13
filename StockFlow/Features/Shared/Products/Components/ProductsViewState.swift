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
    case loaded([ProductsResponse])
    case error(String)
    
    var isLoaded: Bool {
          if case .loaded = self { return true }
          return false
      }
}
