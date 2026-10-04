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
        
        let appStateMenager = AppStateManager(tokenStorage: dependencies.tokenStorage, userRepository: dependencies.userRepository)
        
        _appStateManager = State(initialValue: appStateMenager) //_appStateManager ozune muraciet edir // evvelceden StockFlowwAppde yaradilmis AppStateMenager bura otururuk
    }
    var body: some Scene {
        WindowGroup {
            AppRouter(dependencies: dependencies, appStateManager: appStateManager)
                .task {
                    await appStateManager.readToken()
                }
        }
        
    }
}
