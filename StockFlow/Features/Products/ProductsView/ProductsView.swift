//
//  ProductsView.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//
import SwiftUI
import PhotosUI

struct ProductsView: View {
    
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
        
        filterPicker
        
        ScrollView {
            LazyVStack {
                ForEach(viewModel.filteredProducts){ product in
                    NavigationLink(value: ProductRoute.productDetail(product)) {
                        ProductCardView(product: product)
                    }
                }
            }
        }
        
    }
    
    var header: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Products")
                        .font(.inter(.bold, size: 24))
                    Text("\(viewModel.productsCount)")
                        .font(.inter(.regular, size: 14))
                        .foregroundStyle(.textSecondary)
                }
                Spacer()
                Button {
                    path.append(ProductRoute.addProduct)
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.brandPrimary)
                        Image(systemName: "plus")
                            .font(.inter(.extraBold, size: 18))
                            .foregroundStyle(.white)
                    }
                }
            }
            searchField
        }
    }
    
    var searchField: some View {
        TextField("Search products", text: $viewModel.query)
            .focused($isSearchFocused)
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSearchFocused
                        ? Color.accentColor
                        : Color.clear,
                        lineWidth: 1.5
                    )
                    
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var filterPicker: some View {
        
        HStack {
            ForEach(ProductStockFilter.allCases,id: \.self){ filter in
                Button{
                    viewModel.selectedFilter = filter
                }label: {
                    Text(filter.rawValue)
                        .font(.inter(.regular, size: 12))
                        .foregroundStyle( viewModel.selectedFilter == filter ? .white : .textSecondary)
                        .padding(.horizontal,16)
                        .padding(.vertical,8)
                        .background(viewModel.selectedFilter == filter ? .brandPrimary : .white)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.selectedFilter == filter ? Color.brandPrimarySoft : .gray)

                        }
                        .buttonStyle(.plain)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                }
                
            }
            Spacer()
                .padding()
        }
    }
    

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                header
                content
                
            }
            
            .padding()
            .task {
                await viewModel.loadProducts()
            }
        }
    }
}
#Preview {
    @Previewable @State var selectedImages: [UIImage] = []
    @Previewable @State var selectionItems: [PhotosPickerItem] = []
    @Previewable @State var  path = NavigationPath()
    let dependencies = AppDependencies()
    ProductsView(dependencies: dependencies, viewModel: dependencies.makeProductViewModel(), path: $path, selectionItems: $selectionItems, selectedImages: $selectedImages)
}
