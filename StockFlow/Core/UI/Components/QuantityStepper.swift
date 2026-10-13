//
//  QuantityStepper.swift
//  StockFlow
//
//  Created by Cicek on 13.10.26.
//

import SwiftUI

struct QuantityStepper: View {
    let value: Int
    let canDecrement: Bool
    let canIncrement: Bool
    let onDecrement: () -> Void
    let onIncrement: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: onDecrement) {
                Image(systemName: "minus.circle.fill").font(.system(size: 28))
            }
            .disabled(!canDecrement)

            Text("\(value)")
                .font(.inter(.bold, size: 18))
                .frame(minWidth: 28)

            Button(action: onIncrement) {
                Image(systemName: "plus.circle.fill").font(.system(size: 28))
            }
            .disabled(!canIncrement)
        }
        .buttonStyle(.plain)
    }
}
