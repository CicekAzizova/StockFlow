//
//  UserEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import Foundation

enum UserEndpoint: Endpoint {
    
    case getProfile
    
    var path: String {
        switch self {
        case .getProfile:
             "/users/me"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .getProfile:
                .get
        }
    }
}
