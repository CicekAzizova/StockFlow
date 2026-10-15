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
    @State private var isSplashVisible = true
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
            ZStack {
                AppRouter(dependencies: dependencies, appStateManager: appStateManager)
                
                if  isSplashVisible {
                    SplashView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                let startedAt = ContinuousClock.now
                await appStateManager.readToken()
                let minimumDuration = Duration.seconds(1.2)
                let elapsed = ContinuousClock.now - startedAt
                if !CommandLine.arguments.contains("-uitesting"), elapsed < minimumDuration {
                    try? await Task.sleep(for: minimumDuration - elapsed)
                }
                
                withAnimation(.easeOut(duration: 0.3)) {
                    isSplashVisible = false
                }
            }
            .task {
                for await _ in NotificationCenter.default.notifications(named: .sessionExpired) {
                    appStateManager.logout()
                }
            }
        }
    }
}
