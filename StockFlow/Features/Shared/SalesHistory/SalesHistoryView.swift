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
            await viewModel.loadSalesIfNeeded()
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
            if viewModel.sales.isEmpty {
                ContentUnavailableView(
                    "No sales yet",
                    systemImage: "bag",
                    description: Text("Completed sales will appear here."))
            } else {
                salesList
            }
            
        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task { await viewModel.loadSales() }
                }
            }
        }
    }
    
    private var salesList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.sales, id: \.id) { sale in
                    NavigationLink(value: SalesRoute.detail(sale)) {
                        RecentSalesCardView(sale: sale)
                    }
                    .buttonStyle(.plain)
                    .task {
                        if sale.id == viewModel.sales.last?.id {
                            await viewModel.loadMoreSales()
                        }
                    }
                }
                
                if let error = viewModel.loadMoreError {
                    Text(error)
                        .font(.inter(.regular, size: 13))
                        .foregroundStyle(.textSecondary)
                }
                
            }
            .padding()
        }
    }
}
