//
//  Authentication.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}
