//
//  OwnerTabView.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//
import SwiftUI
import PhotosUI

struct OwnerTabView: View {
    let dependencies: AppDependencies
    let appStateManager: AppStateManager

    let user: User?

    @State private var homePath = NavigationPath()
    @State private var productPath = NavigationPath()
    @State private var teamPath = NavigationPath()
    @State private var selectionItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        TabView {
            Tab {
                NavigationStack(path: $homePath) {
                    if let user {
                        HomeView(
                            viewModel: dependencies.makeHomeViewModel(),
                            path: $homePath,
                            user: user
                        )
                        .navigationDestination(for: HomeRoute.self) { route in
                            switch route {
                            case .lowStock:
                                LowStockView(
                                    viewModel: dependencies.makeLowStockViewModel(), path: $homePath
                                )
                                
                            case .salesHistory:
                                SalesHistoryView(viewModel: dependencies.makeSalesHistoryViewModel())
                            }
                        }
                        .navigationDestination(for: ProductRoute.self) { route in
                            switch route {
                            case .productDetail(let product):
                                ProductDetailView(
                                    viewModel: dependencies.makeProductDetailViewModel(product: product),
                                    path: $homePath
                                )
                            case .editProduct(let product):
                                   AddProductView(
                                       viewModel: dependencies.makeAddProductViewModel(
                                           product: product
                                       ),
                                       selectionItems: $selectionItems,
                                       selectedImages: $selectedImages,
                                       path: $homePath
                                   )

                            default:
                                EmptyView()
                            }
                        }
                    }
                }
                
            }label: {
                Image(.homeIcon)
                    .renderingMode(.template)
                Text("Home")
            }
            Tab {
                NavigationStack(
                    path: $productPath
                ) {
                    OwnerProductsView(
                        dependencies: dependencies,
                        viewModel: dependencies.makeProductViewModel(),
                        path: $productPath,
                        selectionItems: $selectionItems,
                        selectedImages: $selectedImages
                    )
                    .navigationDestination(
                        for: ProductRoute.self
                    ) { route in
                        switch route {
                        case .addProduct:
                            AddProductView(
                                viewModel: dependencies.makeAddProductViewModel(),
                                selectionItems: $selectionItems,
                                selectedImages: $selectedImages,
                                path: $productPath
                            )
                        case .productDetail(
                            let product
                        ):
                            ProductDetailView(viewModel: dependencies.makeProductDetailViewModel(product: product), path: $productPath)
                        case .editProduct(
                            let product
                        ):
                            AddProductView(
                                viewModel: dependencies.makeAddProductViewModel(product: product),
                                selectionItems: $selectionItems,
                                selectedImages: $selectedImages,
                                path: $productPath
                            )
                        }
                    }
                }
            }label: {
                Image(.productsIcon)
                    .renderingMode(.template)
                Text("Products")
            }
            Tab {
                NavigationStack(path: $teamPath) {
                    TeamView(path: $teamPath, viewModel: dependencies.makeTeamViewModel())
                        .navigationDestination(for: TeamRoute.self) { route in
                            switch route {
                            case .addSalesAssociate:
                                AddSalesAssociateView(viewModel: dependencies.makeAddSalesAssociateViewModel(), path: $teamPath)
                            }
                        }
                }
            }label: {
                Image(.teamIcon)
                    .renderingMode(.template)
                Text("Team")
            }
            
            Tab {
                NavigationStack {
                    ProfileView(
                        viewModel: dependencies
                            .makeProfileViewModel(),
                        appStateMenager: appStateManager
                    )
                }
            }label: {
                Image(.profileIcon)
                    .renderingMode(.template)
                Text("Profile")
                    
            }
        }
    }
}
#Preview {
    let dependencies = AppDependencies()
    let appStateManager = AppStateManager(
        tokenStorage: dependencies.tokenStorage, userRepository: dependencies.userRepository
    )
    
    OwnerTabView(
        dependencies: dependencies,
        appStateManager: appStateManager,
        user: User(
            id: 1,
            email: "test@test.com",
            name: "owner",
            role: .owner,
            storeName: "test"
        )
    )
    
}
