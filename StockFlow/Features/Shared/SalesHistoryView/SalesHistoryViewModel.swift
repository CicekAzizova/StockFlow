//
//  SalesHistoryViewModel.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

import Foundation

@Observable
@MainActor
final class SalesHistoryViewModel {

    private let salesStore: SalesStore

    var state: SalesHistoryViewState = .idle
    
    var sales: [SaleResponse] {
        salesStore.recentSales
    }
    var loadMoreError: String?

    init(salesStore: SalesStore) {
        self.salesStore = salesStore
    }
    
    func loadSalesIfNeeded() async {
        guard !state.isLoaded else { return }
        await loadSales()
    }
    
    func loadSales() async {
        let previousState = state
        if !state.isLoaded { state = .loading }

        do {
            try await salesStore.loadRecentSales()
            state = .loaded
        } catch is CancellationError {
            state = previousState
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func refresh() async {
        await loadSales()
    }

    func loadMoreSales() async {
        loadMoreError = nil
        do {
            try await salesStore.loadMoreSales()
        }
        catch is CancellationError {
            return
        }
        catch {
            loadMoreError = error.localizedDescription
        }
    }
}
