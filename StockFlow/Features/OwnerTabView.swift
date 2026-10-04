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

    @State private var path = NavigationPath()
    @State private var selectionItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    if let user {
                        OwnerDashboardView(
                            viewModel: dependencies.makeOwnerDashboardViewModel(),
                            path: $path,
                            user: user
                        )
                    }
                }
                
            }label: {
                Text(
                    "Dashboard"
                )
                Image(
                    .dashboard
                )
                .renderingMode(
                    .template
                )
            }
            Tab {
                NavigationStack(
                    path: $path
                ) {
                    ProductsView(
                        dependencies: dependencies,
                        viewModel: dependencies.makeProductViewModel(),
                        path: $path,
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
                                path: $path
                            )
                        case .productDetail(
                            let product
                        ):
                            ProductDetailView(viewModel: dependencies.makeProductDetailViewModel(product: product), path: $path)
                        case .editProduct(
                            let product
                        ):
                            AddProductView(
                                viewModel: dependencies.makeAddProductViewModel(product: product),
                                selectionItems: $selectionItems,
                                selectedImages: $selectedImages,
                                path: $path
                            )
                        }
                    }
                }
            }label: {
                Text(
                    "Products"
                )
                Image(
                    .products
                )
                .renderingMode(
                    .template
                )
            }
            Tab {
                NavigationStack(path: $path) {
                    TeamView(path: $path)
                        .navigationDestination(for: TeamRoute.self) { route in
                            switch route {
                            case .addSalesAssociate:
                                AddSalesAssociateView()
                            case .salesAssociateDetail:
                                SalesAssociateDetail()
                            }
                        }
                }
            }label: {
                Text(
                    "Team"
                )
                Image(systemName: "person.2.fill")
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
                Text(
                    "Profile"
                )
                Image(systemName: "person.crop.circle")
                    
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
