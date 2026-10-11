//
//  SalesAssociateRequest.swift
//  StockFlow
//
//  Created by Cicek on 05.10.26.
//

import Foundation

struct SalesAssociateRequest: Encodable {
    let name: String
    let surname: String
    let fin: String
    let phone: String
    let email: String
    let password:String
    
    enum CodingKeys: String, CodingKey {
        case email, password, phone, fin
        case name = "name"
        case surname = "surname"
 
    }
}
