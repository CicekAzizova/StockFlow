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
    
    var body: some View {
        TabView {
            Tab {
                NavigationStack {
                    OwnerDashboardView()
                }
                
            }label: {
                Text("Dashboard")
                Image(.dashboard)
                    .renderingMode(.template)
            }
            Tab {
                NavigationStack {
                    Text("Products")
                }
            }label: {
                Text("Products")
                Image(.products)
                    .renderingMode(.template)
            }
            Tab {
                NavigationStack {
                    Text("Inventory")
                }
            }label: {
                Text("Inventory")
                Image(.inventory)
                    .renderingMode(.template)
            }
            Tab {
                NavigationStack {
                    ProfileView(
                        viewModel: dependencies.makeProfileViewModel(),
                        appStateMenager: appStateManager
                    )
                }
            }label: {
                Text("Profile")
                Image(.profile)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20,height: 20)
            }
        }
    }
}
#Preview {
    let dependencies = AppDependencies()
    let appStateManager = AppStateManager(tokenStorage: dependencies.tokenStorage)

    OwnerTabView(dependencies: dependencies, appStateManager: appStateManager)
}
