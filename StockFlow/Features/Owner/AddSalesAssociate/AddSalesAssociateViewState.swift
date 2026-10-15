//
//  AddSalesAssociateViewState.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

enum AddSalesAssociateViewState {
    case idle
    case loading
    case success(SalesAssociateResponse)
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
