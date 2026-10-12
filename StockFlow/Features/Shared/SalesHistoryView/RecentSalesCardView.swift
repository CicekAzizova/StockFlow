//
//  Untitled.swift
//  StockFlow
//
//  Created by Cicek on 03.10.26.
//

import SwiftUI

struct RecentSalesCardView: View {
    let sale: SaleResponse
    
    var body: some View {
        HStack(spacing: 12) {
            
            Image(systemName: "bag")
                .font(.system(size: 20))
                .foregroundStyle(.brandPrimary)
                .frame(width: 40, height: 40)
                .background(.brandPrimary.opacity(0.1))
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
            VStack(alignment: .leading) {
                Text(sale.productName)
                
                Text("\(sale.quantity) × \(sale.unitPrice, specifier: "%.2f") ₼")
//                format: .currency(code: "USD").presentation(.isoCode)
            }
            Spacer()
            Text("\(sale.totalPrice, specifier: "%.2f") ₼")
                .font(.inter(.semiBold, size: 16))
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface)
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
    }
}
