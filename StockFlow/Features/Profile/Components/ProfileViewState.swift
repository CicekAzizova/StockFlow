//
//  ProfileViewState.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import Foundation

enum ProfileViewState {
    case idle
    case loading
    case loaded(User)
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
}
