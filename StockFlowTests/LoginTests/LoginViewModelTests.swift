//
//  LoginViewModelTests.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Testing
@testable import StockFlow

struct LoginViewModelTests {
    @Test
    @MainActor
    func loginSuccess() async {
        //Given
        let repository = MockAuthRepository(
            result: .success(
                LoginResponse(
                    user: User(
                        id: 1,
                        email: "owner@stockflow.com",
                        firstName: "Cicek",
                        lastName: "Owner",
                        role: .owner,
                        storeId: 1
                    ),
                    token: "test_token"
                )
            )
        )
        let viewModel = LoginViewModel(authRepository: repository)
        
        viewModel.email = "owner@stockflow.com"
        viewModel.password = "123456"
        
        //When
        await viewModel.login()
        
        //Then
        guard
            case .loaded(let user) = viewModel.state else {
            Issue.record("Expected loaded state")
            return
        }
        
        #expect(user.email == "owner@stockflow.com")
        #expect(user.role == .owner)
    }
}
