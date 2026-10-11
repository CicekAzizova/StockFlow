//
//  SalesView.swift
//  StockFlow
//
//  Created by Cicek on 06.10.26.
//

import SwiftUI

struct SalesAssociateSalesView: View {

    @State var viewModel: SalesAssociateSalesViewModel

    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            content
        }
        .task {
            await viewModel.loadSales()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded:
            salesView
        case .error(let message):
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
    
    private var salesView: some View {
        VStack {
            Text("Sales")
                .font(.inter(.bold, size: 24))
            
            VStack(alignment: .leading, spacing: 8) {
                        Text("Today's Sales")
                            .font(.inter(.regular, size: 14))
                            .foregroundStyle(.textSecondary)

                        Text("\(viewModel.todaySales, specifier: "%.2f") ₼")
                            .font(.inter(.extraBold, size: 28))

                        Text("\(viewModel.totalOrders) orders")
                            .font(.inter(.regular, size: 13))
                            .foregroundStyle(.textSecondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.border)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
            AppButtonView(
                title: "Scan Product",
                background: .brandPrimary) {
                    path.append(SalesRoute.scanner)
                }
                .padding(.vertical, 16)
            RecentSalesSection(sales: viewModel.recentSales, path: $path)
            
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    SalesAssociateSalesView()
//}
