//
//  SalesHistoryView.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

import SwiftUI

struct SalesHistoryView: View {
    @State var viewModel: SalesHistoryViewModel
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            content
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadSales()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    @ViewBuilder
        private var content: some View {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView()

            case .loaded:
                salesList

            case .error(let message):
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )
            }
        }

        private var salesList: some View {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.sales, id: \.id) { sale in
                        RecentSalesCardView(sale: sale)
                            .task {
                                if sale.id == viewModel.sales.last?.id {
                                    Task {
                                        await viewModel.loadMoreSales()
                                    }
                                }
                            }
                    }
                }
                .padding()
            }
        }
}
