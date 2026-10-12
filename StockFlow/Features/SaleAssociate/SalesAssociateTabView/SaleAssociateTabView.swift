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

                            default:
                                EmptyView()
                            }
                        }
                        
                    }
                }
            }label: {
                Image(.homeIcon)
                    .renderingMode(.template)
                Text("Home")            }
            
            Tab {
                NavigationStack(path: $productPath) {
                    SalesAssociateProductView(
                        dependencies: dependencies,
                        viewModel: dependencies.makeProductViewModel(),
                        
                    )
                    .navigationDestination(for: ProductRoute.self) { route in
                        switch route {
                        case .productDetail(let product):
                            ProductDetailView(viewModel: dependencies.makeProductDetailViewModel(product: product), path: $productPath)
                        default:
                            EmptyView()
                        }
                    }
                }
                
            }label: {
                Image(.productsIcon)
                    .renderingMode(.template)
                Text("Products")            }
            
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
