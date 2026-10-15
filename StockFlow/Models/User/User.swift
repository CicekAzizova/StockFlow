//
//  User.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//
import Foundation

struct User: Decodable {
    let id: Int
    let email: String
    let name: String
    let role: UserRole
    let storeName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case role
        case storeName = "store_name"
    }
}
