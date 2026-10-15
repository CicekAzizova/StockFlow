//
//  SplashView.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import SwiftUI

struct SplashView: View {

    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .scaleEffect(isAnimating ? 1 : 0.8)

                Text("StockFlow")
                    .font(.inter(.extraBold, size: 28))
                    .foregroundStyle(.textPrimary)
            }
            .opacity(isAnimating ? 1 : 0)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    SplashView()
}
