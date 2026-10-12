//
//  Sale.swift
//  StockFlow
//
//  Created by Cicek on 06.10.26.
//

import SwiftUI

struct SaleAssociateTabView: View {
    
    let dependencies: AppDependencies
    let appStateManager: AppStateManager
    @State private var homePath = NavigationPath()
    @State private var productPath = NavigationPath()
    @State private var salesPath = NavigationPath()
    
    let user: User?
    
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
                                path: $homePath
                            )
                        }
                        .navigationDestination(for: ProductRoute.self) { route in
                            ProductDestinationView(
                                route: route,
                                dependencies: dependencies,
                                path: $homePath
                            )
                        }
                        
                    }
                }
            }label: {
                Image(.homeIcon)
                    .renderingMode(.template)
                Text("Home")            }
            
            //MARK: - Products
            
            Tab {
                NavigationStack(path: $productPath) {
                    ProductsView(
                        viewModel: dependencies.makeProductViewModel(),
                        path: $productPath
                    )
                    .navigationDestination(for: ProductRoute.self) { route in
                        ProductDestinationView(
                            route: route,
                            dependencies: dependencies,
                            path: $productPath
                        )
                    }
                }
            }label: {
                Image(.productsIcon)
                    .renderingMode(.template)
                Text("Products")            }
            
            //MARK: - Sales
            Tab {
                NavigationStack(path: $salesPath) {
                    SalesAssociateSalesView(viewModel: dependencies.makeSalesAssociateSalesViewModel(), path: $salesPath)
                    
                        .navigationDestination(for: SalesRoute.self) { route in
                            switch route {
                                
                            case .scanner:
                                BarcodeScannerView()
                                //                    case .cart:
                                //                    case .product(<#T##ProductResponse#>):
                            case .history:
                                SalesHistoryView(viewModel: dependencies.makeSalesHistoryViewModel())
                                
                            }
                        }
                }
                
            }label: {
                Image(.salesIcon)
                    .renderingMode(.template)
                Text("Sales")
                
            }
            
            //MARK: - Profile
            
            Tab {
                ProfileView(viewModel: dependencies.makeProfileViewModel(), appStateManager: appStateManager)
            }label: {
                Image(.profileIcon)
                    .renderingMode(.template)
                Text("Profile")
            }
        }
    }
}
