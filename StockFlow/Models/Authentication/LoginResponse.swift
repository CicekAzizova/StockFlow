//
//  LoginResponse.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

struct LoginResponse: Decodable {
    let user: User
    let token: String
}
