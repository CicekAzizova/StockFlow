//
//  LoginView.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//


import SwiftUI

struct LoginView: View {

    @State var viewModel: LoginViewModel

    @FocusState private var focusedField: FocusedField?

    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
            .background(Color.background)
            .ignoresSafeArea()
    }

    // MARK: - Login Form

    @ViewBuilder
    var loginForm: some View {
        VStack(alignment: .leading, spacing: 0) {

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
                Text(message)
                    .foregroundStyle(.red)
                    .font(.inter(.regular, size: 14))
                    .padding(.top, 12)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Sign In Button

    var signInButton: some View {
        Button {
            Task {
                await viewModel.login()
            }
        } label: {
            Text("Sign In")
                .foregroundStyle(.white)
                .font(.inter(.bold, size: 16))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.primary)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
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

            Button {
                // Create store action
            } label: {
                Text("Create a store")
                    .font(.inter(.bold, size: 14))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
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

        case .loaded(let user):
            Text("Welcome, \(user.firstName)!")
                .font(.inter(.bold, size: 24))

        case .error:
            loginScreen
        }
    }
}

// MARK: - Preview

#Preview("Idle State") {
    LoginView(
        viewModel: AppDependencies().makeLoginViewModel()
    )
}

#Preview("Error State") {
    let viewModel = AppDependencies().makeLoginViewModel()

    viewModel.state = .error(
        "Email və ya password yanlışdır."
    )

    return LoginView(
        viewModel: viewModel
    )
}
