//
//  ProductsView.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//
import SwiftUI
import PhotosUI

struct OwnerProductsView: View {
    
    let dependencies: AppDependencies
    
    @State var viewModel: ProductViewModel
    
    @Binding  var path: NavigationPath
    
    @Binding var selectionItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    @FocusState private var isSearchFocused
    
    
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
                    .task {
                        if product.id == viewModel.filteredProducts.last?.id {
                            await viewModel.loadMoreProducts()
                        }
                    }
                    
                }
            }
            }
        }
        
    }

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                ProductsHeader(count: viewModel.productsCount) {
                    path.append(ProductRoute.addProduct)
                }
                
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
}
#Preview {
    @Previewable @State var selectedImages: [UIImage] = []
    @Previewable @State var selectionItems: [PhotosPickerItem] = []
    @Previewable @State var  path = NavigationPath()
    let dependencies = AppDependencies()
    OwnerProductsView(dependencies: dependencies, viewModel: dependencies.makeProductViewModel(), path: $path, selectionItems: $selectionItems, selectedImages: $selectedImages)
}
