//
//  TeamViewModel.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

import Foundation

@Observable
@MainActor

final class TeamViewModel {
    
    private let repository: SalesAssociateRepository
    
    var state: TeamViewState = .idle
    
    init(repository: SalesAssociateRepository) {
        self.repository = repository
    }
    
    var salesAssociates: [SalesAssociateResponse] = []
    
    func loadSalesAssociates() async {
        state = .loading
        
        do {
            let salesAssociates = try await repository.getSalesAssociates()
            self.salesAssociates = salesAssociates
            state = .loaded(salesAssociates)
        } catch  {
            state = .error(error.localizedDescription)
        }
    }
    
    func deleteSalesAssociate(id: Int) async {
        do {
            try await repository.deleteSalesAssociate(id: id)
            await loadSalesAssociates()
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    var salesAssociateCount: Int {
        salesAssociates.count
    }
    
    var totalSales: Double {
        salesAssociates.first?.totalSalesThisMonth ?? 0
    }
}
