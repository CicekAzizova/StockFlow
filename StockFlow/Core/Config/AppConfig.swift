//
//  AppConfig.swift
//  StockFlow
//
//  Created by Cicek on 12.10.26.
//
import Foundation

enum AppConfig {
    static let baseURL: String = {
        #if targetEnvironment(simulator)
        return "http://localhost:3000"
        #else
        return "http://192.168.1.65:3000"
        #endif
    }()
}
extension AppConfig {
    static func imageURL(from string: String) -> URL? {
        if string.hasPrefix("/") {
            return URL(string: baseURL + string)
        }
        guard var components = URLComponents(string: string),
              let base = URLComponents(string: baseURL) else {
            return URL(string: string)
        }
        components.scheme = base.scheme
        components.host = base.host
        components.port = base.port
        return components.url
    }
}
