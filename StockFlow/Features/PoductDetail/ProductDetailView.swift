//
//  ProductDetailView.swift
//  StockFlow
//
//  Created by Cicek on 02.10.26.
//
import SwiftUI

struct ProductDetailView: View {
    @State var viewModel: ProductDetailViewModel
    
    @Binding var path: NavigationPath
    @State private var showingDeleteConfirmation = false
    
    private var product: ProductResponse {
        viewModel.product
    }
    
    private var isLowStock: Bool {
        product.quantity <= product.lowStockLimit
    }
    init(
        viewModel: ProductDetailViewModel,
        path: Binding<NavigationPath>
    ) {
        _viewModel = State(initialValue: viewModel)
        _path = path
    }
    
    private var imageGallery: some View {
        TabView {
            ForEach(
                Array((product.imageUrls ?? []).prefix(5).enumerated()),
                id: \.offset
            ) { _, imageUrl in
                RemoteImageView(
                    imageUrl: imageUrl,
                    width: 280,
                    height: 280,
                    cornerRadius: 16
                )
                .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 280)
        .tabViewStyle(.page)
    }
    
    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.inter(.extraBold, size: 20))

                Text(product.sku)
                    .font(.inter(.regular, size: 13))
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            Text(product.stockStatus.text(quantity: product.quantity))
                .font(.inter(.bold, size: 11))
                .foregroundStyle(product.stockStatus.color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(product.stockStatus.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var productInformation: some View {
        VStack(spacing: 20) {
            informationRow(
                title: "Category",
                value: product.category
            )

            informationRow(
                title: "Price",
                value: product.price.formatted(
                    .currency(code: "USD").presentation(.isoCode)))

            informationRow(
                title: "Discount",
                value: product.discount.formatted(.number.precision(.fractionLength(0))) + "%",
                valueColor: .completed
            )

            informationRow(
                title: "Current stock",
                value: "\(product.quantity) units"
            )

            informationRow(
                title: "Low-stock threshold",
                value: "\(product.lowStockLimit) units"
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.border, lineWidth: 1)
        }
    }

    private func informationRow(
        title: String,
        value: String,
        valueColor: Color = .primary
    ) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .foregroundStyle(valueColor)
        }
        .font(.inter(.regular, size: 15))
    }
    
    private var productDetailContent: some View {
        ScrollView {
            VStack(spacing: 20) {
                imageGallery
                header
                productInformation
                actionButtons
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .confirmationDialog(
            "Delete Product",
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteProduct()
                    
                    if case .deleted = viewModel.state {
                        path.removeLast()
                    }
                    

                }
            }

            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this product?")
        }
    }
    
    private var actionButtons: some View {
        Button(role: .destructive) {
                    showingDeleteConfirmation = true
                } label: {
                    Text("Delete Product")
                        .font(.inter(.regular, size: 15))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
    }
    
    var body: some View {
        content
            .navigationTitle("\(product.name) details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        path.append(ProductRoute.editProduct(product))
                    } label: {
                        Text("Edit")
                            .foregroundStyle(.brandPrimary)
                            .font(.inter(.bold, size: 16))
                    }
                }
            }
    }
    
   
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            productDetailContent
            
        case .deleting:
            productDetailContent
                .overlay {
                    ProgressView("Deleting product...")
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            
        case .deleted:
            ContentUnavailableView(
                "Product Deleted",
                systemImage: "checkmark.circle",
                description: Text("The product has been successfully deleted.")
            )
            
        case .error(let message):
            ContentUnavailableView(
                "Something Went Wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
    
    
}
