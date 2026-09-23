//
//  AppDependencies.swift
//  StockFlow
//
//  Created by Cicek on 21.09.26.
//
import Foundation

final class AppDependencies {
    
    let networkService: NetworkService
    let authService: AuthService
    let tokenStorage: TokenStoring
    let authRepository: AuthRepository
    
    
    init() {
        
    let networkService = DefaultNetworkService()
    let authService = MockAuthService()
    let tokenStorage = KeychainWrapper()
    let authRepository = DefaultAuthRepository(authService: authService, keychainService: tokenStorage)
     
        self.networkService = networkService
        self.authService = authService
        self.tokenStorage = tokenStorage
        self.authRepository = authRepository
    }
    
    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(authRepository: authRepository)
    }
}
