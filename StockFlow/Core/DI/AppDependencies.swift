//
//  AppDependencies.swift
//  StockFlow
//
//  Created by Cicek on 21.09.26.
//


final class AppDependencies {
    let networkService: NetworkService
    
    let tokenStorage: TokenStoring
    
    let authRepository: AuthRepository
    
    let storeRepository: StoreRepository
    
    let userRepository: UserRepository
    
    let productRepository: ProductRepository
    
    let productsStore: ProductsStore
    
    let salesAssociateRepository: SalesAssociateRepository
    
    let salesStore: SalesStore
    let salesRepository: SalesRepository
    
    

    init() {
        let tokenStorage = KeychainWrapper()
        let networkService = DefaultNetworkService(tokenStoring: tokenStorage)

 
        let authRepository = DefaultAuthRepository(
            networkService: networkService,
            tokenStorage: tokenStorage
        )

        let storeRepository = DefaultStoreRepository(
            networkService: networkService,
            tokenStorage: tokenStorage
        )
        
        let userRepository = DefaultUserRepository(
            networkService: networkService
        )
        
        let productRepository = DefaultProductRepository(networkService: networkService)
        
        let productsStore = ProductsStore(productRepository: productRepository)
        
        let salesAssociateRepository = DefaultSalesAssociateRepository(networkService: networkService)
 
        let salesRepository = DefaultSalesRepository(networkService: networkService)
        let salesStore = SalesStore(salesRepository: salesRepository)
        
        self.tokenStorage = tokenStorage
        self.networkService = networkService

        self.authRepository = authRepository
        
        self.storeRepository = storeRepository
        
        self.userRepository = userRepository
        
        self.productRepository = productRepository
        
        self.productsStore = productsStore
        
        self.salesAssociateRepository = salesAssociateRepository
        
        self.salesRepository = salesRepository
        self.salesStore = salesStore
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
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            productStore: productsStore, salesStore: salesStore
        )
    }
    
    @MainActor
    func makeAddSalesAssociateViewModel() -> AddSalesAssociateViewModel {
        AddSalesAssociateViewModel(repository: salesAssociateRepository)
    }
    
    @MainActor
    func makeTeamViewModel() -> TeamViewModel {
        TeamViewModel(repository: salesAssociateRepository)
    }
    
    @MainActor
    func makeSalesAssociateSalesViewModel() -> SalesAssociateSalesViewModel {
        SalesAssociateSalesViewModel(salesStore: salesStore)
    }
    
    @MainActor
    func makeSalesHistoryViewModel() -> SalesHistoryViewModel {
        SalesHistoryViewModel(salesStore: salesStore)
    }
    
    @MainActor
    func makeLowStockViewModel() -> LowStockViewModel {
        LowStockViewModel(productStore: productsStore)
    }
}
