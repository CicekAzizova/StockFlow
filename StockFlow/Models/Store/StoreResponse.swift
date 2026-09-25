//
//  StoreResponse.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

struct StoreResponse: Decodable {

    let id: Int
    let name: String
    let email: String
    let phone: String
    let storeName: String
    let storeAddress: String
    let storePhone: String
    let createdAt: String
    let token: String
    
}
