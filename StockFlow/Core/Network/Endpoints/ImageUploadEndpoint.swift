//
//  ImageUploadEndpoint.swift
//  StockFlow
//
//  Created by Cicek on 16.10.26.
//

import Foundation

enum ImageUploadEndpoint: Endpoint {
    case upload

    var path: String { "/uploads/images" }
    var method: HttpMethod { .post }
}
