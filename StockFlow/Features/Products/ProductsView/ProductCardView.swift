//
//  ProductCardView.swift
//  StockFlow
//
//  Created by Cicek on 30.09.26.
//
import SwiftUI

struct ProductCardView: View {
    
    var product: ProductResponse
    
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
                Text(product.sku)
                    .font(.inter(.regular, size: 12))
                    .foregroundStyle(.disabled)
                Text(
                    product.price,
                    format: .currency(code: "USD").presentation(.isoCode)
                )
                    .font(.inter(.bold, size: 14))
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
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
