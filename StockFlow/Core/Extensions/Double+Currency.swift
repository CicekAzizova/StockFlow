//
//  Double+Currency.swift
//  StockFlow
//
//  Created by Cicek on 12.10.26.
//
import Foundation

extension Double {
    var asCurrency: String {
        formatted(
            .currency(code: "USD")
                .locale(Locale(identifier: "en_US"))
        )
    }
    var asCompactCurrency: String {
            formatted(
                .currency(code: "USD")
                    .locale(Locale(identifier: "en_US"))
                    .notation(.compactName)
                    .precision(.fractionLength(0...1))
            )
        }
}
