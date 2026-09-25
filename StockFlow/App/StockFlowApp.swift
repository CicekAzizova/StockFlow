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
    let appStateMenager: AppStateManager
    
    init() {
        let dependencies = AppDependencies()
        self.dependencies = dependencies
        
        let appStateMenager = AppStateManager(tokenStorage: dependencies.tokenStorage)
        
        appStateMenager.readToken()
        
        self.appStateMenager = appStateMenager
    }
    var body: some Scene {
        WindowGroup {
            AppRouter(appStateManager: appStateMenager, dependencies: dependencies)
        }
    }
}
