//
//  AddProductsVies.swift
//  StockFlow
//
//  Created by Cicek on 27.09.26.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @State var viewModel: AddProductViewModel
    
    @FocusState private var focusField: AddProductFocusedField?
    
    @Binding var selectionItems: [PhotosPickerItem]
    @Binding var selectedImages: [UIImage]
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            content
            
        }
        .navigationTitle("Add Products")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var addProductScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                header
                AddProductImageView(selectionItems: $selectionItems,selectedImages: $selectedImages)
                form
                addProductButton
            }
            .padding(.horizontal,24)
        }
    }
    
    var header: some View {
        VStack(alignment: .leading){
            Text("Product information")
                .font(.inter(.regular, size: 20))
            Text("This same form is used when editing a product.")
                .font(.inter(.regular, size: 13))
        }
        .padding(.bottom, 16)
    }
        
    
    @ViewBuilder
    var form: some View {
        
        AppTextFieldView(
            title: "Product name",
            placeholder: "Enter Product name",
            icon: nil,
            focusedField: .name,
            submitLabel: .next,
            onSubmit: {
                focusField = .sku
            },
            text: $viewModel.name,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "SKU",
            placeholder: "Enter unique SKU",
            icon: nil,
            focusedField: .sku,
            submitLabel: .next,
            onSubmit: {
                focusField = .category
            },
            text: $viewModel.sku,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Category",
            placeholder: "Enter product category",
            icon: nil,
            focusedField: .category,
            submitLabel: .next,
            onSubmit: {
                focusField = .description
            },
            text: $viewModel.category,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Description",
            placeholder: "Enter product description",
            icon: nil,
            focusedField: .description,
            submitLabel: .next,
            onSubmit: {
                focusField = .price
            },
            text: $viewModel.description,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Price",
            placeholder: "Enter product price",
            icon: nil,
            focusedField: .price,
            keyboardType: .decimalPad,
            submitLabel: .next,
            onSubmit: {
                focusField = .discount
            },
            text: $viewModel.price,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Discount",
            placeholder: "Enter discount",
            icon: nil,
            focusedField: .discount,
            submitLabel: .next,
            onSubmit: {
                focusField = .costPrice
            },
            text: $viewModel.discount,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Cost price",
            placeholder: "Enter cost price",
            icon: nil,
            focusedField: .costPrice,
            submitLabel: .next,
            onSubmit: {
                focusField = .quantity
            },
            text: $viewModel.costPrice,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Quantity",
            placeholder: "Enter quantity",
            icon: nil,
            focusedField: .quantity,
            keyboardType: .numberPad,
            submitLabel: .next,
            onSubmit: {
                focusField = .lowStockLimit
            },
            text: $viewModel.quantity,
            focusedFieldBinding: $focusField
        )
        
        AppTextFieldView(
            title: "Low stock limit",
            placeholder: "Enter low stock limit",
            icon: nil,
            focusedField: .lowStockLimit,
            submitLabel: .done,
            onSubmit: {
                focusField = nil
            },
            text: $viewModel.lowStockLimit,
            focusedFieldBinding: $focusField
        )
    }
    
    var addProductButton: some View {
        VStack {
            if let message = viewModel.validationMessage {
                Text(message)
                    .font(.inter(.regular, size: 13))
                    .foregroundStyle(.error)
            }
            AppButtonView(
                title: "Add Product",
                isLoading: viewModel.state.isLoading,
                background: .brandPrimary) {
                    Task {
                        await viewModel.createProduct()
                        
                        if case .success = viewModel.state {
                            selectionItems = []
                            selectedImages = []
                            
                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    }
                }
            if case .error = viewModel.state {
                Text("Something went wrong. Please try again.")
                    .font(.inter(.regular, size: 13))
                    .foregroundStyle(.error)
            }
        }
            .padding(.top, 16)
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle:
            addProductScreen
        case .loading:
            ProgressView("Adding Product...")
        case .success:
            Color.clear
                
            
        case .error:
            addProductScreen
        }
    }
}
//#Preview {
//    NavigationStack {
//        AddProductView()
//    }
//}
