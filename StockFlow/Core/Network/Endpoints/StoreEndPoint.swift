//
//  StoreEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

enum StoreEndpoint: Endpoint {
    
    case createStore(StoreRequest)
    
    
    var path: String {
        switch self {
        case .createStore:
            "/auth/register"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .createStore:
                .post
        }
    }
    var requiresAuthentication: Bool {
        false
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .createStore(let request):
            return request
        }
    }
}
