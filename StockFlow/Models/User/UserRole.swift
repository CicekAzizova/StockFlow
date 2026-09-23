//
//  UserRole.swift
//  StockFlow
//
//  Created by Cicek on 20.09.26.
//

import Foundation

enum UserRole: String, Decodable {
    case owner = "OWNER"
    case salesAssociate = "SALES_ASSOCIATE"
}
