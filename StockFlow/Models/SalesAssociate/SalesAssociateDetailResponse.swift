////
////  SalesAssociateDetailResponse.swift
////  StockFlow
////
////  Created by Cicek on 06.10.26.
////
//
//struct SalesAssociateDetailResponse: Decodable {
//    let id: Int
//    let name: String
//    let surname: String
//    let fin: String
//    let email: String
//    let phone: String
//    let role: UserRole
//    let storeId: Int
//    
//    let overview: Overview
//    let periods: Periods
//    let salesHistory: [SalesHistory]
//    let recentSales: [RecentSale]
//    let products: [Product]
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case surname
//        case fin
//        case email
//        case phone
//        case role
//        case storeId = "store_id"
//        case overview
//        case periods
//        case salesHistory = "sales_history"
//        case recentSales = "recent_sales"
//        case products
//    }
//    
//}
//
//extension SalesAssociateDetailResponse {
//    
//    struct Overview: Decodable {
//        let totalSales: Double
//        let totalTransactions: Int
//        
//        enum CodingKeys: String, CodingKey {
//            case totalSales = "total_sales"
//            case totalTransactions = "total_transactions"
//        }
//    }
//    
//    struct Periods: Decodable {
//        let today: Period
//        let thisWeek: Period
//        let thisMonth: Period
//        
//        enum CodingKeys: String, CodingKey {
//            case today
//            case thisWeek = "this_week"
//            case thisMonth = "this_month"
//        }
//    }
//    
//    struct Period: Decodable {
//        let totalSales: Double
//        let totalTransactions: Int?
//        
//        enum CodingKeys: String, CodingKey {
//            case totalSales = "total_sales"
//            case totalTransactions = "total_transactions"
//        }
//    }
//    
//    struct SalesHistory: Decodable {
//        let date: String
//        let totalSales: Double
//        let totalTransactions: Int
//        
//        enum CodingKeys: String, CodingKey {
//            case date
//            case totalSales = "total_sales"
//            case totalTransactions = "total_transactions"
//        }
//    }
//    
//    struct RecentSale: Decodable {
//        let id: Int
//        let productId: Int
//        let productName: String
//        let sku: String
//        let quantity: Int
//        let unitPrice: Double
//        let totalPrice: Double
//        let createdAt: String
//        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case productId = "product_id"
//            case productName = "product_name"
//            case sku
//            case quantity
//            case unitPrice = "unit_price"
//            case totalPrice = "total_price"
//            case createdAt = "created_at"
//        }
//    }
//    
//    struct Product: Decodable {
//        let id: Int
//        let name: String
//        let sku: String
//        let transactionCount: Int
//        let unitsSold: Int
//        let totalSales: Double
//        
//        enum CodingKeys: String, CodingKey {
//            case id
//            case name
//            case sku
//            case transactionCount = "transaction_count"
//            case unitsSold = "units_sold"
//            case totalSales = "total_sales"
//        }
//    }
//}
