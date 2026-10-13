//
//  ProductCardView.swift
//  StockFlow
//
//  Created by Cicek on 30.09.26.
//
import SwiftUI

struct SummaryCardView: View {
    
    var product: ProductsResponse
    
    var body: some View {
        HStack {
            RemoteImageView(
                imageUrl: product.imageUrls?.first,
                width: 60,
                height: 60
            )
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.inter(.bold, size: 15))
                    .foregroundStyle(.textPrimary)
                Text(product.sku)
                    .font(.inter(.regular, size: 12))
                    .foregroundStyle(.textSecondary)
                Text(
                    product.price.asCurrency
                )
                    .font(.inter(.bold, size: 14))
                    .foregroundStyle(.primaryBlue)
            }
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            Text(product.stockStatus.text(quantity: product.quantity))
                .foregroundStyle(product.stockStatus.color)
                .font(.inter(.bold, size: 11))
                .padding(.horizontal, 8)
                .padding(.vertical,4)
                .background(product.stockStatus.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
         .frame(maxWidth: .infinity)
        .padding()
        .background(.surface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
