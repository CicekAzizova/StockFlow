//
//  SummaryGridView.swift
//  StockFlow
//
//  Created by Cicek on 06.10.26.
//
import SwiftUI

struct SummaryGridView: View {
    
    let title: String
    let value: String
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(iconColor)
                .frame(width: 50, height: 50)
                .background(iconColor.opacity(0.08))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.inter(.extraBold, size: 24))
                    .foregroundStyle(.primary)
                
                Text(title)
                    .font(.inter(.regular, size: 12))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            
            Spacer(minLength: 0)
            
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
        .background(.border)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.gray.opacity(0.15), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
    
}
