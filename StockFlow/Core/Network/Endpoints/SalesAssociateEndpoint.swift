//
//  SalesAssociateEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

enum SalesAssociateEndpoint: Endpoint {
   
    case addSalesAssociate(SalesAssociateRequest)
    case getSalesAssociates
    case delete(id: Int)
    
    var path: String {
        switch self {
        case .addSalesAssociate:
            "/users/sales-associate"
        case .delete(let id):
            "/users/\(id)"
        case .getSalesAssociates:
            "/users"
        }
    }
    
    var requiresAuthentication: Bool {
        true
    }
    
    var method: HttpMethod {
        switch self {
        case .addSalesAssociate:
                .post
        case .delete:
                .delete
        case .getSalesAssociates:
                .get
        }
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .addSalesAssociate(let request):
            return request
        case .delete:
            return nil
        case .getSalesAssociates:
            return nil
        }
    }
    
}
