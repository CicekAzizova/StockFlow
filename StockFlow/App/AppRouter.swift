//
//  AppRouter.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//


import SwiftUI

struct AppRouter: View {
    
    @State var appStateManager: AppStateManager
    var dependencies: AppDependencies
    
    var body: some View {
         content
    }
    
    @ViewBuilder
    var content: some View {
        switch appStateManager.state {
        case .loading:
            ProgressView()
        case .unauthenticated:
            LoginView(viewModel: dependencies.makeLoginViewModel(), dependencies: dependencies, appStateManager: appStateManager)
        case .authenticated:
            OwnerTabView(dependencies: dependencies, appStateManager: appStateManager)
        }
    }
}
