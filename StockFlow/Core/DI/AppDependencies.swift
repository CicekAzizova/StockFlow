//
//  AppDependencies.swift
//  StockFlow
//
//  Created by Cicek on 21.09.26.
//
final class AppDependencies {
    let networkService: NetworkService
    
    let tokenStorage: TokenStoring
    
    let authService: AuthService
    let authRepository: AuthRepository
    
    let storeService: StoreService
    let storeRepository: StoreRepository
    
    let userService: UserService
    let userRepository: UserRepository
    

    init() {
        let tokenStorage = KeychainWrapper()
        let networkService = DefaultNetworkService(tokenStoring: tokenStorage)

        let authService = MockAuthService()
        let authRepository = DefaultAuthRepository(
            authService: authService,
            tokenStorage: tokenStorage
        )

        let storeService = MockStoreService()
        let storeRepository = DefaultStoreRepository(
            storeService: storeService,
            tokenStorage: tokenStorage
        )
        
        let userService = MockUserService()
        let userRepository = DefaultUserRepository(
            userService: userService,
            tokenStorage: tokenStorage
        )

        self.tokenStorage = tokenStorage
        self.networkService = networkService

        self.authService = authService
        self.authRepository = authRepository
        
        self.storeService = storeService
        self.storeRepository = storeRepository
        
        self.userService = userService
        self.userRepository = userRepository
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
    
    @MainActor
    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(userRepository: userRepository)
    }
}
