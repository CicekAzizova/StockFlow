//
//  LoginView.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//


import SwiftUI

struct LoginView: View {

    @State var viewModel: LoginViewModel
    
    let dependencies: AppDependencies
    let appStateManager: AppStateManager

    @FocusState private var focusedField: CreateStoreFocusedField?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.background
                    .ignoresSafeArea()

                content
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(24)
            }
        }
    }

    // MARK: - Login Form

    @ViewBuilder
    var loginForm: some View {
        VStack(alignment: .leading, spacing: 8) {

            Image(.logo)

            Text("Welcome back")
                .font(.inter(.extraBold, size: 30))

            Text("Sign in to manage Harbor & Pine.")
                .font(.inter(.regular, size: 15))
                .foregroundStyle(.textSecondary)
                .padding(.bottom, 32)

            AppTextFieldView(
                title: "Email",
                placeholder: "Owner",
                icon: "envelope",
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
                submitLabel: .done,
                onSubmit: {
                    Task {
                        await viewModel.login()
                    }
                },
                text: $viewModel.password,
                focusedFieldBinding: $focusedField
            )

            if case .error(let message) = viewModel.state {
                ErrorMessageView(message: message)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Sign In Button

    var signInButton: some View {
        AppButtonView(
            title: "Sign In",

            isLoading: viewModel.state.isLoading, background: .brandPrimary,
        ) {
            Task {
                await viewModel.login()
                if case .loaded(_) = viewModel.state {
                    appStateManager.state = .authenticated
                }
            }
        }
        
        .padding(.top, 50)
    }

    // MARK: - Footer

    var footer: some View {
        VStack(alignment: .center) {

            Text("New to StockFlow?")
                .font(.inter(.regular, size: 15))
                .foregroundStyle(.textSecondary)
                .padding(.bottom, 32)

            createStoreButton
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
    
    var createStoreButton: some View {
        NavigationLink {
            CreateStoreView(
                viewModel: dependencies
                    .makeCreateStoreViewModel(), appStateManager: appStateManager
            )
        } label: {
            Text("Create Store")
                .font(.inter(.medium, size: 15))
                .foregroundStyle(.brandPrimary)
        }
    }

    // MARK: - Login Screen

    var loginScreen: some View {
        VStack {
            VStack(alignment: .leading) {
                loginForm
                signInButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            footer
        }
    }

    // MARK: - Content

    @ViewBuilder
    var content: some View {
        switch viewModel.state {

        case .idle:
            loginScreen

        case .loading:
            ProgressView("Signing in...")

        case .loaded:
            ProgressView()
            
        case .error:
            loginScreen
        }
    }
}

// MARK: - Preview

#Preview("Idle State") {
    let dependencies = AppDependencies()
    let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage)


    LoginView(
        viewModel: dependencies.makeLoginViewModel(),
        dependencies: dependencies, appStateManager: appStateManager
    )
}

#Preview("Error State") {
    let dependencies = AppDependencies()
    let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage)

    let viewModel = dependencies.makeLoginViewModel()

    viewModel.state = .error(
        "Email və ya password yanlışdır."
    )

    return LoginView(viewModel: viewModel, dependencies: dependencies, appStateManager: appStateManager)
}
