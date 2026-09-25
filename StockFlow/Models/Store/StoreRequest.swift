//
//  StoreRequest.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

struct StoreRequest: Encodable {
    let name: String
    let email: String
    let password:String
    let phone: String
    let storeName: String
    let storeAddress: String
    let storePhone: String
}
