//
//  OwnerTabView.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//
import SwiftUI

struct OwnerTabView: View {
    let dependencies: AppDependencies
    let appStateManager: AppStateManager

    let user: User?

    @State private var homePath = NavigationPath()
    @State private var productPath = NavigationPath()
    @State private var teamPath = NavigationPath()
    
    var body: some View {
        TabView {
            
            //MARK: - Home
            
            Tab {
                NavigationStack(path: $homePath) {
                    if let user {
                        HomeView(
                            viewModel: dependencies.makeHomeViewModel(),
                            path: $homePath,
                            user: user
                        )
                        .navigationDestination(for: HomeRoute.self) { route in
                            HomeDestinationView(
                                route: route,
                                dependencies: dependencies,
                                path: $homePath,
                            )
                        }
                        .navigationDestination(for: ProductRoute.self) { route in
                            ProductDestinationView(
                                route: route,
                                dependencies: dependencies,
                                path: $homePath,
                                canManageProducts: true
                            )
                        }
                        .navigationDestination(for: SalesRoute.self) { route in
                            SalesDestinationView(route: route, dependencies: dependencies)
                        }
                    }
                }
                
            } label: {
                Image(.homeIcon)
                    .renderingMode(.template)
                Text("Home")
            }
            
            //MARK: - Products
            
            Tab {
                NavigationStack(
                    path: $productPath
                ) {
                    ProductsView(
                        viewModel: dependencies.makeProductViewModel(),
                        path: $productPath,
                        canManageProducts: true
                    )
                    .navigationDestination(
                        for: ProductRoute.self
                    ) { route in
                        ProductDestinationView(
                            route: route,
                            dependencies: dependencies,
                            path: $productPath,
                            canManageProducts: true
                        )
                    }
                }
            } label: {
                Image(.productsIcon)
                    .renderingMode(.template)
                Text("Products")
            }
            
            //MARK: - Team
            
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
            } label: {
                Image(.teamIcon)
                    .renderingMode(.template)
                Text("Team")
            }
            
            //MARK: - Profile
            
            Tab {
                NavigationStack {
                    ProfileView(
                        viewModel: dependencies
                            .makeProfileViewModel(),
                        appStateManager: appStateManager
                    )
                }
            } label: {
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
