//
//  RecentSalesSection.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//
import SwiftUI

struct RecentSalesSection: View {
    
    let sales: [SaleResponse]
    let onSeeAll: () -> Void
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Sales")
                    .font(.inter(.bold, size: 18))
                Spacer()
                if !sales.isEmpty {
                    Button("See All", action: onSeeAll)
                        .font(.inter(.medium, size: 13))
                        .foregroundStyle(.seeAllButton)
                        .padding(.trailing, 8)
                }
            }
            
            if sales.isEmpty {
                Text("No sales yet")
                    .font(.inter(.regular, size: 14))
                    .foregroundStyle(.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 10) {
                    ForEach(sales, id: \.id) { sale in
                        Button {
                            path.append(SalesRoute.detail(sale))
                        }label: {
                            RecentSalesCardView(sale: sale)
                        }
                    }
                }
            }
        }
    }
}
