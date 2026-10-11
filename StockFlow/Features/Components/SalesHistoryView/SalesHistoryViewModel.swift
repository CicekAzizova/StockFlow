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

    init(salesStore: SalesStore) {
        self.salesStore = salesStore
    }

    func loadSales() async {
        state = .loading

        do {
            try await salesStore.loadRecentSales(limit: 10)
            state = .loaded
        } catch is CancellationError {
            return
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func refresh() async {
        await loadSales()
    }

    func loadMoreSales() async {
        do {
            try await salesStore.loadMoreSales(limit: 10)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    var sales: [SaleResponse] {
        salesStore.recentSales
    }
    
}
