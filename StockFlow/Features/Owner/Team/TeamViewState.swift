//
//  TeamViewState.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

enum TeamViewState {
    case idle
    case loading
    case loaded
    case error(String)
    
    var isLoaded: Bool {
        if case .loaded = self { return true }
        return false
    }
}
