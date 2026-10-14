//
//  LoginViewModelTests.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Testing
@testable import StockFlow

@MainActor
struct LoginViewModelTests {

    private func makeSUT(
        result: Result<LoginResponse, Error>? = nil
    ) -> (viewModel: LoginViewModel, repository: MockAuthRepository, appState: AppStateManager) {
        let repository = MockAuthRepository(result: result ?? .success(TestData.loginResponse))
        let appState = AppStateManager(
            tokenStorage: MockTokenStorage(),
            userRepository: MockUserRepository()
        )
        let viewModel = LoginViewModel(authRepository: repository, appStateManager: appState)
        return (viewModel, repository, appState)
    }

    @Test func loginSucceeds() async {
        let sut = makeSUT()
        sut.viewModel.email = "owner@stockflow.com"
        sut.viewModel.password = "123456"

        await sut.viewModel.login()

        guard case .loaded(let user) = sut.viewModel.state else {
            Issue.record("Expected .loaded state")
            return
        }
        #expect(user.email == "owner@stockflow.com")
        #expect(sut.appState.state == .authenticated)
        #expect(sut.repository.loginCallCount == 1)
    }

    @Test func loginFailureShowsError() async {
        let sut = makeSUT(result: .failure(TestError.failed))
        sut.viewModel.email = "owner@stockflow.com"
        sut.viewModel.password = "123456"

        await sut.viewModel.login()

        guard case .error(let message) = sut.viewModel.state else {
            Issue.record("Expected .error state")
            return
        }
        #expect(message == "Test failure")
        #expect(sut.appState.state != .authenticated)
    }

    @Test func emptyEmailIsRejectedWithoutCallingRepository() async {
        let sut = makeSUT()
        sut.viewModel.email = ""
        sut.viewModel.password = "123456"

        await sut.viewModel.login()

        #expect(sut.viewModel.fieldErrors[.email] == "Email is required.")
        #expect(sut.repository.loginCallCount == 0)
    }

    @Test func invalidEmailIsRejected() async {
        let sut = makeSUT()
        sut.viewModel.email = "not-an-email"
        sut.viewModel.password = "123456"

        await sut.viewModel.login()

        #expect(sut.viewModel.fieldErrors[.email] == "Enter a valid email.")
        #expect(sut.repository.loginCallCount == 0)
    }

    @Test func shortPasswordIsRejected() async {
        let sut = makeSUT()
        sut.viewModel.email = "owner@stockflow.com"
        sut.viewModel.password = "123"

        await sut.viewModel.login()

        #expect(sut.viewModel.fieldErrors[.password] == "Password must contain at least 6 characters.")
        #expect(sut.repository.loginCallCount == 0)
    }
}
