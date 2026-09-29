//
//  ProductsEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import Foundation

enum ProductsEndpoint: Endpoint {
    
    case createProduct(ProductRequest)
    case getProducts
    case search(query: String)
    
    var path: String {
        switch self {
        case .createProduct:
            "/products"
        case .getProducts:
            "/products"
        case .search:
            "/products"
        }
    }
    
    var method: HttpMethod {
        switch self {
        case .createProduct:
                .post
        case .getProducts:
                .get
        case .search:
                .get
        }
    }
    
    var requiresAuthentication: Bool {
        true
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .createProduct(let request):
            request
        case .getProducts:
            nil
        case .search:
            nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createProduct:
            return nil
        case .getProducts:
            return nil
        case .search(let query):
            return [URLQueryItem(name: "query", value: query)]
        }
    }
    
}
