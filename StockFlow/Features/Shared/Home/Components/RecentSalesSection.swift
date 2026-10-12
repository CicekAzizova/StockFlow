//
//  RecentSalesSection.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//
import SwiftUI

struct RecentSalesSection: View {

    let sales: [SaleResponse]
    @Binding var path: NavigationPath

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Sales")
                    .font(.inter(.bold, size: 18))
                Spacer()
                
                Button("See All") {
                    path.append(HomeRoute.salesHistory)
                }
                .font(.inter(.medium, size: 13))
                .foregroundStyle(.primaryBlue)
            }
            
            LazyVStack {
                ForEach(sales, id: \.id) { sale in
                    Button {
                        
                        //
                    }label: {
                        RecentSalesCardView(sale: sale)
                    }
                }
            }
        }
    }
}
