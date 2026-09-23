//
//  StockFlowApp.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import SwiftUI

@main
struct StockFlowApp: App {
    let dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: dependencies.makeLoginViewModel())
        }
    }
}
