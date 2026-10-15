//
//  SalesAssociateRepository.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

import Foundation

protocol SalesAssociateRepository {
    func addSalesAssociate(request: SalesAssociateRequest) async throws -> SalesAssociateResponse
    func getSalesAssociates() async throws -> [SalesAssociateResponse]

    func deleteSalesAssociate(id: Int) async throws 
}

final class DefaultSalesAssociateRepository: SalesAssociateRepository {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func addSalesAssociate(request: SalesAssociateRequest) async throws -> SalesAssociateResponse {
        try await networkService.request(SalesAssociateEndpoint.addSalesAssociate(request))
    }
    
    func getSalesAssociates() async throws -> [SalesAssociateResponse] {
        try await networkService.request(SalesAssociateEndpoint.getSalesAssociates)
    }
    
    func deleteSalesAssociate(id: Int) async throws  {
       try await networkService.requestVoid(SalesAssociateEndpoint.delete(id: id))
    }
}
