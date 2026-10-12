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

    @ViewBuilder
    private var form: some View {

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
            keyboardType: .decimalPad,
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
            keyboardType: .decimalPad,
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
            keyboardType: .numberPad,
            submitLabel: .done,
            onSubmit: {
                focusField = nil
            },
            text: $viewModel.lowStockLimit,
            focusedFieldBinding: $focusField
        )
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
