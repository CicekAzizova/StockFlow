//
//  Extensions.swift
//  StockFlow
//
//  Created by Cicek on 12.10.26.
//

import Foundation

extension String {
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidEmail: Bool {
        range(of: #"^[^\s@]+@[^\s@]+\.[^\s@]+$"# , options: .regularExpression) != nil
    }
}

extension String {
    var asDecimal: Double? {
        Double(trimmingCharacters(in: .whitespaces).replacingOccurrences(of: ",", with: "."))
    }
}
