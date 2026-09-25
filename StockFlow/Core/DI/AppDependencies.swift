//
//  AppDependencies.swift
//  StockFlow
//
//  Created by Cicek on 21.09.26.
//
final class AppDependencies {
    let networkService: NetworkService
    let authService: AuthService
    let tokenStorage: TokenStoring
    let authRepository: AuthRepository
    let storeService: StoreService
    let storeRepository: StoreRepository

    init() {
        let networkService = DefaultNetworkService()

        let authService = MockAuthService()
        let tokenStorage = KeychainWrapper()

        let authRepository = DefaultAuthRepository(
            authService: authService,
            tokenStorage: tokenStorage
        )

        let storeService = MockStoreService()

        let storeRepository = DefaultStoreRepository(
            storeService: storeService,
            tokenStorage: tokenStorage
        )

        self.networkService = networkService
        self.authService = authService
        self.tokenStorage = tokenStorage
        self.authRepository = authRepository
        self.storeService = storeService
        self.storeRepository = storeRepository
    }

    @MainActor
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(
            authRepository: authRepository
        )
    }

    @MainActor
    func makeCreateStoreViewModel() -> CreateStoreViewModel {
        CreateStoreViewModel(
            storeRepository: storeRepository
        )
    }
}
