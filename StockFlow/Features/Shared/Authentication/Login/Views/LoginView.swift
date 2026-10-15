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
            .dismissKeyboardOnTap()
        }
    }

    // MARK: - Login Form

    @ViewBuilder
    var loginForm: some View {
        VStack(alignment: .leading, spacing: 8) {

            Image(.logo)

            Text("Welcome back")
                .font(.inter(.extraBold, size: 30))
                .foregroundStyle(.textPrimary)

            Text("Sign in to manage Harbor & Pine.")
                .font(.inter(.regular, size: 15))
                .foregroundStyle(.textSecondary)
                .padding(.bottom, 32)

            AppTextFieldView(
                title: "Email",
                placeholder: "email",
                icon: "envelope",
                focusedField: .email,
                errorMessage: viewModel.fieldErrors[.email],
                textContentType: .emailAddress,
                keyboardType: .emailAddress,
                submitLabel: .next,
                onSubmit: {
                    focusedField = .password
                },
                accessibilityID: "loginEmailField",
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
                        await performLogin()
                    }
                },
                accessibilityID: "loginPasswordField",
                text: $viewModel.password,
                focusedFieldBinding: $focusedField
            )

            if case .error(let message) = viewModel.state {
                ErrorMessageView(message: message)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }



    var signInButton: some View {
        AppButtonView(
            title: "Sign In",

            isLoading: viewModel.state.isLoading,
            background: .brandPrimary,
        ) {
            Task {
                await performLogin()
            }
        }
        .padding(.top, 50)
    }

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
            CreateStoreView(viewModel: dependencies.makeCreateStoreViewModel(appStateManager: appStateManager))
        } label: {
            Text("Create Store")
                .font(.inter(.medium, size: 15))
                .foregroundStyle(.primaryBlue)
        }
    }


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

    @MainActor
    private func performLogin() async {
        await viewModel.login()
    }

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
    let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage, userRepository: dependencies.userRepository)


    LoginView(
        viewModel: dependencies.makeLoginViewModel(appStateManager: appStateManager),
        dependencies: dependencies, appStateManager: appStateManager
    )
   
}

#Preview("Error State") {
    let dependencies = AppDependencies()
    let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage, userRepository: dependencies.userRepository)

    let viewModel = dependencies.makeLoginViewModel(appStateManager: appStateManager)

    viewModel.state = .error(
        "Email və ya password yanlışdır."
    )

   return LoginView(viewModel: viewModel, dependencies: dependencies, appStateManager: appStateManager)
       
}
