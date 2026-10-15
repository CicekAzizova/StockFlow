//
//  LowStockView.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

import SwiftUI

struct LowStockView: View {
    @State var viewModel: LowStockViewModel
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            content
        }
        .navigationTitle("Low Stock")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadProductsIfNeeded()
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
            if viewModel.products.isEmpty {
                ContentUnavailableView(
                    "Stock levels are healthy",
                    systemImage: "checkmark.circle",
                    description: Text("No products are running low.")
                )
            } else {
                lowStockList
            }

        case .error(let message):
            ContentUnavailableView {
                Label("Something went wrong", systemImage: "exclamationmark.triangle")
            } description: {
                Text(message)
            } actions: {
                Button("Try again") {
                    Task { await viewModel.loadProducts() }
                }
            }
        }
    }

    private var lowStockList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.products, id: \.id) { product in
                    Button {
                        path.append(ProductRoute.productDetail(product))
                    } label: {
                        SummaryCardView(product: product)
                    }
                    .buttonStyle(.plain)
                    .task {
                        if product.id == viewModel.products.last?.id {
                            await viewModel.loadMoreProducts()
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
