//
//  CreateStoreView.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//

import SwiftUI

struct CreateStoreView: View {

    @State var viewModel: CreateStoreViewModel
    let appStateManager: AppStateManager


    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
       
            ZStack {
                Color.background
                    .ignoresSafeArea()

                content
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
            }
    }

    // MARK: - Content

    @ViewBuilder
    var content: some View {
        switch viewModel.state {

        case .idle:
            createStoreScreen

        case .loading:
            ProgressView("Creating store...")

        case .loaded:
            successView

        case .error(let message):
            createStoreScreen
                .overlay(alignment: .top) {
                    errorMessage(message)
                }
        }
    }

    // MARK: - Create Store Screen

    var createStoreScreen: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    header
                    form
                }
                .padding(24)
            }
            .scrollDismissesKeyboard(.interactively)
            
            createStoreButton
                
        }
    }

    // MARK: - Header

    var header: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(.roleIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .padding(.top, 12)
            Text(
                "Your account is automatically assigned the OWNER role with full management access."
            )
            .font(.inter(.regular, size: 15))
            .foregroundStyle(.textSecondary)
            .padding(.bottom, 32)
        }
    }

    // MARK: - Form

    @ViewBuilder
    var form: some View {

        AppTextFieldView(
            title: "Full Name",
            placeholder: "Your name",
            icon: nil,
            focusedField: .name,
            errorMessage: viewModel.fieldErrors[.name],
            submitLabel: .next,
            onSubmit: {
                focusedField = .email
            },
            text: $viewModel.name,
            focusedFieldBinding: $focusedField
        )

        AppTextFieldView(
            title: "Email",
            placeholder: "you@example.com",
            icon: nil,
            focusedField: .email,
            errorMessage: viewModel.fieldErrors[.email],
            textContentType: .emailAddress,
            keyboardType: .emailAddress,
            submitLabel: .next,
            onSubmit: {
                focusedField = .password
            },
            text: $viewModel.email,
            focusedFieldBinding: $focusedField
        )

        AppSecureFieldView(
            placeholder: "Password",
            focusedField: .password,
            errorMessage: viewModel.fieldErrors[.password],
            submitLabel: .next,
            onSubmit: {
                focusedField = .phone
            },
            text: $viewModel.password,
            focusedFieldBinding: $focusedField
        )

        AppTextFieldView(
            title: "Phone",
            placeholder: "+994",
            icon: nil,
            focusedField: .phone,
            errorMessage: viewModel.fieldErrors[.phone],
            keyboardType: .phonePad,
            submitLabel: .next,
            onSubmit: {
                focusedField = .storeName
            },
            text: $viewModel.phone,
            focusedFieldBinding: $focusedField
        )

        AppTextFieldView(
            title: "Store Name",
            placeholder: "Your store name",
            icon: nil,
            focusedField: .storeName,
            errorMessage: viewModel.fieldErrors[.storeName],
            submitLabel: .next,
            onSubmit: {
                focusedField = .storeAddress
            },
            text: $viewModel.storeName,
            focusedFieldBinding: $focusedField
        )

        AppTextFieldView(
            title: "Store Address",
            placeholder: "Store address",
            icon: nil,
            focusedField: .storeAddress,
            errorMessage: viewModel.fieldErrors[.storeAddress],
            submitLabel: .next,
            onSubmit: {
                focusedField = .storePhone
            },
            text: $viewModel.storeAddress,
            focusedFieldBinding: $focusedField
        )

        AppTextFieldView(
            title: "Store Phone",
            placeholder: "+994",
            icon: nil,
            focusedField: .storePhone,
            errorMessage: viewModel.fieldErrors[.storePhone],
            keyboardType: .phonePad,
            submitLabel: .done,
            onSubmit: {
                focusedField = nil
            },
            text: $viewModel.storePhone,
            focusedFieldBinding: $focusedField
        )
    }

    // MARK: - Create Store Button

    var createStoreButton: some View {
        AppButtonView(
            title: "Create Store",
            isLoading: viewModel.state.isLoading
        ) {
            Task {
                await viewModel.createStore()
                
                if case .loaded(_) = viewModel.state {
                
                            }
            }
            
            
        }
        .padding(.top, 32)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .background(Color.background)
    }

    // MARK: - Success View

    var successView: some View {
        VStack(spacing: 16) {

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundStyle(.green)

            Text("Store created successfully!")
                .font(.inter(.bold, size: 22))
                .multilineTextAlignment(.center)
        }
        .padding(24)
    }

    // MARK: - Error Message

    func errorMessage(_ message: String) -> some View {
        Text(message)
            .font(.inter(.regular, size: 14))
            .foregroundStyle(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.top, 12)
    }
}

// MARK: - Preview

#Preview {
    let dependencies = AppDependencies()
    let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage)


    CreateStoreView(
        viewModel: dependencies.makeCreateStoreViewModel(), appStateManager: appStateManager
    )
}
