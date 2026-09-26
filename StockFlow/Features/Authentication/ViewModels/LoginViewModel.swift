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
    
    var fieldErrors: [FocusedField: String] = [:]
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
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
            let result = try await authRepository.login(email: email, password: password)
            
            state = .loaded(result.user)
            
        } catch let error  {
            state = .error(error.localizedDescription)
        }
    }
    
    private func validateFields() -> Bool {
        fieldErrors.removeAll()
        
        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.email] = "Email is required."
        } else if !email.contains("@") {
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
