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
            await viewModel.loadProducts()
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
            lowStockList

        case .error(let message):
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
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
                }
            }
            .padding()
        }
    }
}
