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
    let firstName: String
    let lastName: String
    let role: UserRole
    let storeId: Int
  
    
}
