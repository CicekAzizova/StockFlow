//
//  ProfileInfoCardView.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import SwiftUI

struct ProfileInfoCardView: View {
    var title: String
    var subTitle: String
    var icon: String
    var showDivider: Bool
    
    var card: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                    .padding(8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.surface.opacity(0.2))
                    }
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundStyle(.textSecondary)
                        .font(.inter(.regular, size: 12))
                    Text(subTitle)
                        .font(.inter(.medium, size: 14))
                }
                Spacer()
            }
            .padding(12)
            if showDivider {
                Divider()
            }
        }
    }
    var body: some View {
         card
            
    }
}

