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
    private let appStateManager: AppStateManager

    
    var fieldErrors: [LoginFocusedField: String] = [:]
    
    init(authRepository: AuthRepository,
         appStateManager: AppStateManager) {
        self.authRepository = authRepository
        self.appStateManager = appStateManager

    }
    
    var state: LoginViewState = .idle
    var email: String = ""
    var password: String = ""
  
    func login() async {
        guard validateFields() else {
                return
        }
        
        state = .loading
        do {
            let response = try await authRepository.login(email: email, password: password)
            
            appStateManager.setUser(response.user)

            state = .loaded(response.user)
            
        } catch let error  {
            state = .error(error.localizedDescription)
        }
    }
    
    private func validateFields() -> Bool {
        fieldErrors.removeAll()
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.email] = "Email is required."
        } else if !email.contains("@"), !email.contains(".") {
            fieldErrors[.email] = "Enter a valid email."
        }
        
        if password.isEmpty {
            fieldErrors[.password] = "Password is required."
        } else if password.count < 6 {
            fieldErrors[.password] = "Password must contain at least 6 characters."
        }
        return fieldErrors.isEmpty
    }
}
