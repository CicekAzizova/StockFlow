//
//  AppStateMenager.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//

import Foundation
import Observation

@Observable
final class  AppStateManager {
    var state: AppState = .loading
    
    private let tokenStorage: TokenStoring
    
    init(tokenStorage: TokenStoring) {
        self.tokenStorage = tokenStorage
    }
    
    func readToken() {
        state = .loading
        do {
            let token = try  tokenStorage.readToken()
            
            if let token , !token.isEmpty {
                state = .authenticated
            }else {
                state = .unauthenticated
            }
        } catch  {
            state = .unauthenticated
        }
    }
}
