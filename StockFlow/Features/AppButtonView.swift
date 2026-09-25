//
//  AppButtonView.swift
//  StockFlow
//
//  Created by Cicek on 24.09.26.
//

import SwiftUI

struct AppButtonView: View {

    let title: String
    var isLoading: Bool = false
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(title)
                        .font(.inter(.bold, size: 16))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.brandPrimary)
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )
        }
        .disabled(isLoading)
    }
}
