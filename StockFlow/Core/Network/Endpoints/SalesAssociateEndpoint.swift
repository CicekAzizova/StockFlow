//
//  SalesAssociateEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

enum SalesAssociateEndpoint: Endpoint {
   
    case addSalesAssociate(SalesAssociateRequest)
    case detailSalesAssociate
    
    var path: String {
        switch self {
        case .addSalesAssociate:
            ""
        case .detailSalesAssociate:
            ""
        }
    }
    
    var requiresAuthentication: Bool {
        true
    }
    
    var method: HttpMethod {
        switch self {
        case .addSalesAssociate:
                .post
        case .detailSalesAssociate:
                .get
        }
    }
    
    var httpBody: (any Encodable)? {
        switch self {
        case .addSalesAssociate(let request):
            return request
        case .detailSalesAssociate:
            return nil
        }
    }
    
}
