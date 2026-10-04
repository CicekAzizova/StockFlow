//
//  OwnerDashboardView.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//

import SwiftUI

struct OwnerDashboardView: View {
    
    @State var viewModel: OwnerDashboardViewModel
    @Binding var path: NavigationPath
    
    let user: User
    
    init(
        viewModel: OwnerDashboardViewModel,
        path: Binding<NavigationPath>,
        user: User
    ) {
        self._viewModel = State(initialValue: viewModel)
        self._path = path
        self.user = user
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Good morning, \(user.name)")
                .font(.inter(.regular, size: 13))
            Text("\(user.storeName ?? "")")
                .font(.inter(.extraBold, size: 20))
            Text("Owner access • Products, inventory & sales")
                .font(.inter(.regular, size: 13))
                .padding()
                .frame(maxWidth: .infinity)
                .background(.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
        }
    }
    
    var dashboardView: some View {
        VStack(alignment: .leading) {
            header
            ScrollView {
                allProductsInfo
                recentSales
                needsAttention
            }
        }
        .padding()
    }
    
    var allProductsInfo: some View {
        Grid(horizontalSpacing: 16, verticalSpacing: 16) {
            GridRow {
                gridRowView(
                    title: "Today’s sales",
                    quantity: "_",
                    icon: "chart.bar",
                    iconColor: .blue
                )
                
                gridRowView(
                    title: "Revenue",
                    quantity: "-",
                    icon: "dollarsign.circle",
                    iconColor: .green
                )
            }
            
            GridRow {
                gridRowView(
                    title: "Total products",
                    quantity: "\(viewModel.productsCount)",
                    icon: "cube",
                    iconColor: .blue
                )
                
                gridRowView(
                    title: "Low stock",
                    quantity: "\(viewModel.lowStockCount)",
                    icon: "exclamationmark.triangle",
                    iconColor: .orange
                )
            }
        }
    }
    
    private func gridRowView(
        title: String,
        quantity: String,
        icon: String,
        iconColor: Color
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 50, height: 50)
                .background(iconColor.opacity(0.08))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(quantity)
                    .font(.inter(.extraBold, size: 24))
                    .foregroundStyle(.primary)
                
                Text(title)
                    .font(.inter(.regular, size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
            
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.15), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
    
    var recentSales: some View {
        VStack(alignment: .leading) {
                LazyVStack {
                    ForEach(viewModel.lowStockProducts){ product in
                        RecentSalesCardView()
                    }
                }
        }
    }
    var needsAttention: some View {
        VStack(alignment: .leading) {
            Text("Needs Attention")
                .font(.inter(.bold, size: 18))
                LazyVStack {
                    ForEach(viewModel.lowStockProducts){ product in
                        ProductCardView(product: product)
                    }
                }
        }
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            content
        }
        .task {
            await viewModel.loadDashboard()
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
            dashboardView

        case .error(let error):
            ContentUnavailableView {
                Label(
                    "Something went wrong",
                    systemImage: "exclamationmark.triangle"
                )
            } description: {
                Text(String(describing: error))
            } actions: {
                Button("Retry") {
                    Task {
                        await viewModel.refresh()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
