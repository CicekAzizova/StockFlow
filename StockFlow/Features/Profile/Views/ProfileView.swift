//
//  ProfileView.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import SwiftUI

struct ProfileView: View {
    @State var viewModel: ProfileViewModel
    let appStateMenager: AppStateManager
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            content
                .padding(12)
            }
        .navigationTitle("Profile")
        .task {
            await viewModel.getUser()
        }
    }
    
    @ViewBuilder
    func profileView(user: User) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                ProfileHeaderView(user: user)
                
                VStack {
                    
                    ProfileInfoCardView(
                        title: "Full Name",
                        subTitle: "Cicek Azizova",
                        icon: "person",
                        showDivider: true,
                        
                    )
                    ProfileInfoCardView(
                        title: "Email",
                        subTitle: "Cicek Azizova",
                        icon: "person",
                        showDivider: true,
                        
                    )
                    ProfileInfoCardView(
                        title: "Store",
                        subTitle: "Cicek Azizova",
                        icon: "person",
                        showDivider: false
                    )
                }
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                
                Spacer()
                
                AppButtonView(title: "Log Out", background: .red) {
                    appStateMenager.logout()
                }
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let user):
            profileView(user: user)
        case .error(let message):
            ContentUnavailableView(
                "Error",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}

//#Preview {
//    NavigationStack {
//        ProfileView(viewModel: ProfileViewModel(userRepository: ))
//    }
//}
