//
//  StockFlowApp.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import SwiftUI

@main
struct StockFlowApp: App {
    let dependencies: AppDependencies
    
    @State private var appStateManager: AppStateManager
    
    init() {
        let dependencies = AppDependencies()
        self.dependencies = dependencies
        
        let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage, userRepository: dependencies.userRepository)
        
        appStateManager.onLogout = {
            dependencies.productsStore.reset()
            dependencies.salesStore.reset()
        }
        
        _appStateManager = State(initialValue: appStateManager)
    }
    var body: some Scene {
        WindowGroup {
            AppRouter(dependencies: dependencies, appStateManager: appStateManager)
                .task {
                    await appStateManager.readToken()
                }
                .task {
                    for await _ in NotificationCenter.default.notifications(named: .sessionExpired) {
                        appStateManager.logout()
                    }
                }
        }
        
    }
}
