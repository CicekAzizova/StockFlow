//
//  StoreEndPoint.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

enum StoreEndpoint: Endpoint {
    case createStore(
        name: String,
        email: String,
        password: String,
        phone: String,
        storeName: String,
        storeAddress: String,
        storePhone: String
    )
    
    
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
    
    var httpBody: (any Encodable)? {
        switch self {
        case .createStore(
           let name,
           let email,
           let password,
           let phone,
           let storeName,
           let storeAddress,
           let storePhone
        ):
            
            return StoreRequest(name: name, email: email, password: password, phone: phone, storeName: storeName, storeAddress: storeAddress, storePhone: storePhone)
        }
    }
}
