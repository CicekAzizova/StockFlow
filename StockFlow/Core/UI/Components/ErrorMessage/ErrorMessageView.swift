//
//  ErrorMessageView.swift
//  StockFlow
//
//  Created by Cicek on 26.09.26.
//

import SwiftUI

struct ErrorMessageView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.inter(.regular, size: 14))
            .foregroundStyle(.red)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
            .padding(.top, 12)
    }
}
