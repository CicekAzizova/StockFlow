//
//  ProfileViewModel.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import Foundation

@MainActor
@Observable
final class ProfileViewModel {
    
    private let userRepository: UserRepository
    
    var state: ProfileViewState = .idle
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUser() async {
        state = .loading
        
        do {
           let response = try await userRepository.getUser()
            state = .loaded(response)
        } catch let error  {
            state = .error(error.localizedDescription)
        }
    }
}
