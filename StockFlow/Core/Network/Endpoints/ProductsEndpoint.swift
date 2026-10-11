//
//  ProductsEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import Foundation

enum ProductsEndpoint: Endpoint {
    
    case createProduct(ProductRequest)
    case getProducts(page: Int, limit: Int)
    case getLowStockProducts(page: Int, limit: Int)
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
        case .deleteProduct(let id):
            "/products/\(id)"
        case .getLowStockProducts:
            "/products/low-stock"
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
        case .getLowStockProducts:
                .get
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
        case .getLowStockProducts:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createProduct:
            return nil
        case .editProduct:
            return nil
        case .deleteProduct:
            return nil
        case .search(let query):
            return [URLQueryItem(name: "query", value: query)]
        case .getProducts(let page,let limit):
             return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit",value: String(limit))
            ]
        case .getLowStockProducts(let page,let limit):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "limit", value: String(limit))
            ]
        }
    }
}
