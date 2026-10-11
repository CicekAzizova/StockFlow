//
//  TeamViewState.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

enum TeamViewState {
    case idle
    case loading
    case loaded([SalesAssociateResponse])
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
