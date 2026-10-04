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
    case editProduct(id: Int, request: ProductRequest)
    case deleteProduct(id: Int)
    
    var path: String {
        switch self {
        case .createProduct:
            "/products"
        case .getProducts:
            "/products"
        case .search:
            "/products"
        case .editProduct(let id,_):
            "/products/\(id)"
        case .deleteProduct(id: let id):
            "/products/\(id)"
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
        case .editProduct:
                .put
        case .deleteProduct:
                .delete
        }
    }
    
    var requiresAuthentication: Bool {
        true
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .createProduct(let request):
            return request
        case .getProducts:
            return nil
        case .search:
            return nil
        case .editProduct(_, let request):
            return request
        case .deleteProduct:
            return nil
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
        case .editProduct:
            return nil
        case .deleteProduct:
            return nil
        }
    }
}
