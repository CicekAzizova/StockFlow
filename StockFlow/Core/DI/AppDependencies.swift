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
    
    let productService: ProductService
    let productRepository: ProductRepository
    
    let productsStore: ProductsStore
    

    init() {
        let tokenStorage = KeychainWrapper()
        let networkService = DefaultNetworkService(tokenStoring: tokenStorage)

        let authService = DefaultAuthService(networkService: networkService)
        let authRepository = DefaultAuthRepository(
            authService: authService,
            tokenStorage: tokenStorage
        )

        let storeService = DefaultStoreService(networkService: networkService )
        let storeRepository = DefaultStoreRepository(
            storeService: storeService,
            tokenStorage: tokenStorage
        )
        
        let userService = DefaultUserService(networkService: networkService)
        let userRepository = DefaultUserRepository(
            userService: userService,
            tokenStorage: tokenStorage
            
        )
        
        let productService = DefaultProductService(networkService: networkService)
        let productRepository = DefaultProductRepository(productService: productService)
        
        let productsStore = ProductsStore(productRepository: productRepository)

        self.tokenStorage = tokenStorage
        self.networkService = networkService

        self.authService = authService
        self.authRepository = authRepository
        
        self.storeService = storeService
        self.storeRepository = storeRepository
        
        self.userService = userService
        self.userRepository = userRepository
        
        self.productService = productService
        self.productRepository = productRepository
        
        self.productsStore = productsStore
    }

    @MainActor
    func makeLoginViewModel(    appStateManager: AppStateManager) -> LoginViewModel {
        LoginViewModel(
            authRepository: authRepository, appStateManager: appStateManager
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
    
    @MainActor
    func makeAddProductViewModel(product: ProductResponse? = nil) -> AddProductViewModel {
        AddProductViewModel(
            productStore: productsStore,
            product: product, tokenStorage: tokenStorage
        )
    }
    
    @MainActor
    func makeProductViewModel() -> ProductViewModel {
        ProductViewModel(productStore: productsStore)
    }
    
    @MainActor
    func makeProductDetailViewModel(product: ProductResponse) -> ProductDetailViewModel {
        ProductDetailViewModel(productStore: productsStore, product: product)
    }
    
    @MainActor
    func makeOwnerDashboardViewModel() -> OwnerDashboardViewModel {
        OwnerDashboardViewModel(
            productStore: productsStore
        )
    }
}
