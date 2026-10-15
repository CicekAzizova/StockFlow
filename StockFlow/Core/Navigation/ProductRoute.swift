//
//  ProductRoute.swift
//  StockFlow
//
//  Created by Cicek on 28.09.26.
//

import Foundation

enum ProductRoute: Hashable {
    case addProduct
    case productDetail(ProductsResponse)
    case editProduct(ProductsResponse)
}
