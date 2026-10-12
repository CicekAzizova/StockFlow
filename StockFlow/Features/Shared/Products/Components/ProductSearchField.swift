//
//  ProductSearchField.swift
//  StockFlow
//
//  Created by Cicek on 09.10.26.
//

import SwiftUI

struct ProductSearchField: View {
    @Binding var query: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        TextField("Search products", text: $query)
            .focused($isFocused)
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(.border)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused
                        ? Color.accentColor
                        : Color.clear,
                        lineWidth: 1.5
                    )
                    
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
