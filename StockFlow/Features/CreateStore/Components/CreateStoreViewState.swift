//
//  StoreViewState.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

enum CreateStoreViewState {
    case idle
    case loading
    case success(StoreResponse)
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
