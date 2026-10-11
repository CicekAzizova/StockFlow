//
//  SalesAssociateProductView.swift
//  StockFlow
//
//  Created by Cicek on 06.10.26.
//

import SwiftUI
import PhotosUI

struct SalesAssociateProductView: View {
    
    let dependencies: AppDependencies
    
    @State var viewModel: ProductViewModel
    
    @FocusState private var isSearchFocused
    
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                ProductsHeader(count: viewModel.productsCount)
                
                ProductSearchField(query: $viewModel.query)
                
                content
                
            }
            .padding()
            .task {
                await viewModel.loadProducts()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
    
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let products):
            if products.isEmpty {
                ContentUnavailableView(
                    "No Products",
                    systemImage: "shippingbox",
                    description: Text("Add your first product to get started.")
                )
            } else {
                productsList(products: viewModel.filteredProducts)
            }
        case .error(let message):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
    
    @ViewBuilder
    private func productsList(products: [ProductResponse]) -> some View {
        VStack {
            ProductFilterPicker(selectedFilter: $viewModel.selectedFilter)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredProducts,id: \.id){ product in
                        NavigationLink(value: ProductRoute.productDetail(product)) {
                            SummaryCardView(product: product)
                        }
                    }
                }
            }
        }
        
    }
}


