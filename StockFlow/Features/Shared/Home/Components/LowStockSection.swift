//
//  LowStockSection.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//

import SwiftUI

struct LowStockSection: View {

    let products: [ProductsResponse]
    
    @Binding var path: NavigationPath

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Needs Attention")
                    .font(.inter(.bold, size: 18))
                Spacer()
                
                Button("See All") {
                    path.append(HomeRoute.lowStock)
                }
                .font(.inter(.medium, size: 13))
                .foregroundStyle(.primaryBlue)
            }
            LazyVStack {
                ForEach(products, id: \.id) { product in
                    Button {
                        path.append(ProductRoute.productDetail(product))

                    }label: {
                        SummaryCardView(product: product)
                    }
                        
                }
            }
        }
    }
}
