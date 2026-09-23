//
//  LoginViewModel.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation
import Observation

@MainActor
@Observable
final class LoginViewModel {
    private let authRepository: AuthRepository
    var alert: LoginAlert?
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    var state: LoginViewState = .idle
    var email: String = ""
    var password: String = ""
    var user: User?
    
    func login() async {
        state = .loading
        do {
            let result = try await authRepository.login(email: email, password: password)
            user = result.user
            state = .loaded(result.user)
            
        } catch let error  {
            state = .error(error.localizedDescription)
            alert = LoginAlert(
                   title: "Login failed",
                   message: "Email və ya password yanlışdır."
               )
        }
    }
}
