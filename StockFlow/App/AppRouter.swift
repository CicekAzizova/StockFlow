//
//  AppRouter.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//


import SwiftUI

struct AppRouter: View {
    
    var dependencies: AppDependencies
    let appStateManager: AppStateManager
    
    var body: some View {
         content
    }
    
    @ViewBuilder
    var content: some View {
        switch appStateManager.state {
        case .loading:
            ProgressView()
        case .unauthenticated:
            LoginView(viewModel: dependencies.makeLoginViewModel(appStateManager: appStateManager), dependencies: dependencies, appStateManager: appStateManager)
        case .authenticated:
            switch appStateManager.user?.role {
            case .owner:
                OwnerTabView(
                    dependencies: dependencies,
                    appStateManager: appStateManager,
                    user: appStateManager.user
                )
            case .salesAssociate:
                SaleAssociateTabView(
                    dependencies: dependencies,
                    appStateManager: appStateManager,
                    user: appStateManager.user
                )
            case .none:
                ProgressView()
            }
        }
    }
}
