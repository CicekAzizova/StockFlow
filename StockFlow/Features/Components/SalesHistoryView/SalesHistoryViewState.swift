//
//  SalesHistoryViewState.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

enum SalesHistoryViewState {
    case idle
    case loading
    case loaded
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
