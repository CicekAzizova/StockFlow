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
    
    var salesAssociateCount: Int {
        salesAssociates.count
    }
    
    var totalSales: Double {
        salesAssociates.first?.totalSalesThisMonth ?? 0
    }
    
    func loadSalesAssociates() async {
        let previousState = state
        if !state.isLoaded { state = .loading }
        
        do {
            salesAssociates = try await repository.getSalesAssociates()
            state = .loaded
        }
        catch is CancellationError {
            state = previousState
        }
        catch  {
            state = .error(error.localizedDescription)
        }
    }
    
    func refresh() async {
        await loadSalesAssociates()
    }
}
