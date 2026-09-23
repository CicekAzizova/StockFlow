//
//  AuthEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

enum AuthEndpoint: Endpoint {
    
    case login(email: String,password: String)
    
    var path: String {
        switch self {
        case .login(let email, let password):
            return "/auth/login"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .login(let email, let password):
            return .post
        }
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .login(let email, let password):
            return LoginRequest(
                email: email,
                password: password
            )
        }
    }
}
