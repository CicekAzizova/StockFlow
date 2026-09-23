//
//  LoginViewState.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

enum LoginViewState {
    case idle
    case loading
    case loaded(User)
    case error(String)
}
