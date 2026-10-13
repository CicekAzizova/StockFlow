//
//  AddProductsVies.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//


import SwiftUI

struct AddProductView: View {
    
    @State private var viewModel: AddProductViewModel
    @FocusState private var focusField: AddProductFocusedField?
    @Binding var path: NavigationPath
    @State private var showScanner = false
    
    let product: ProductsResponse?
    
    private var isEditMode: Bool {
        viewModel.product != nil
    }
    
    init(
        viewModel: AddProductViewModel,
        path: Binding<NavigationPath>
    ) {
        self._viewModel = State(initialValue: viewModel)
        self.product = viewModel.product
        self._path = path
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            content
        }
        .navigationTitle(isEditMode ? "Edit Product" : "Add Product")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showScanner) {
                NavigationStack {
                    BarcodeInputView(showsManualEntry: false) { code in
                        viewModel.sku = code
                        showScanner = false
                    }
                    .navigationTitle("Scan SKU")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showScanner = false }
                        }
                    }
                }
            }
    }
    
    // MARK: - Add Product Screen
    
    private var addProductScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                header
                
                AddProductImageView(viewModel: viewModel)
                
                form
                
                addProductButton
            }
            .padding(.horizontal, 24)
        }
    }
    
    // MARK: - Header
    
    private var header: some View {
        VStack(alignment: .leading) {
            Text(isEditMode ? "Edit product information" : "Product information")
                .font(.inter(.regular, size: 20))
            
            Text(
                isEditMode
                ? "Update the details of your product."
                : "Enter the details of your new product."
            )
            .font(.inter(.regular, size: 13))
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Form
    
    private func field(
        _ title: String,
        _ placeholder: String,
        _ focus: AddProductFocusedField,
        next: AddProductFocusedField?,
        keyboard: UIKeyboardType = .default,
        icon: String? = nil,
        iconAction: (() -> Void)? = nil,
        text: Binding<String>
    ) -> some View {
        AppTextFieldView(
            title: title,
            placeholder: placeholder,
            icon: icon,
            focusedField: focus,
            keyboardType: keyboard,
            submitLabel: next == nil ? .done : .next,
            onSubmit: { focusField = next },
            iconAction: iconAction,
            text: text,
            focusedFieldBinding: $focusField
        )
    }
    
    @ViewBuilder
    private var form: some View {
        field("Product name", "Enter Product name", .name, next: .sku, text: $viewModel.name)
        field(
            "SKU", "Enter unique SKU", .sku, next: .category,
            icon: "barcode.viewfinder",
            iconAction: { showScanner = true },
            text: $viewModel.sku
        )
        field("Category", "Enter product category", .category, next: .description, text: $viewModel.category)
        field("Description", "Enter product description", .description, next: .price, text: $viewModel.description)
        field("Price", "Enter product price", .price, next: .discount, keyboard: .decimalPad, text: $viewModel.price)
        field("Discount", "Enter discount", .discount, next: .costPrice, keyboard: .decimalPad, text: $viewModel.discount)
        field("Cost price", "Enter cost price", .costPrice, next: .quantity, keyboard: .decimalPad, text: $viewModel.costPrice)
        field("Quantity", "Enter quantity", .quantity, next: .lowStockLimit, keyboard: .numberPad, text: $viewModel.quantity)
        field("Low stock limit", "Enter low stock limit", .lowStockLimit, next: nil, keyboard: .numberPad, text: $viewModel.lowStockLimit)
    }
    
    // MARK: - Add / Save Button
    
    private var addProductButton: some View {
        VStack(spacing: 8) {
            
            if let message = viewModel.validationMessage {
                Text(message)
                    .font(.inter(.regular, size: 13))
                    .foregroundStyle(.error)
                    .multilineTextAlignment(.center)
            }
            
            if case .error(let message) = viewModel.state {
                Text(message)
                    .font(.inter(.regular, size: 13))
                    .foregroundStyle(.error)
                    .multilineTextAlignment(.center)
            }
            
            AppButtonView(
                title: isEditMode ? "Save Product" : "Add Product",
                isLoading: viewModel.state.isLoading,
                background: .brandPrimary
            ) {
                Task {
                    await submitProduct()
                }
            }
        }
        .padding(.top, 16)
    }
    
    // MARK: - Submit Product
    
    @MainActor
    private func submitProduct() async {
        
        await viewModel.saveProduct()
        
        if case .success = viewModel.state {
            
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
    
    // MARK: - Content State
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            addProductScreen
            
        case .success:
            Color.clear
            
        case .error:
            addProductScreen
        }
    }
}
