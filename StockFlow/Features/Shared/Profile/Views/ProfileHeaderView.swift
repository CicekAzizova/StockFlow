//
//  ProfileHeaderView.swift
//  StockFlow
//
//  Created by Cicek on 25.09.26.
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 24) {
            ZStack {
                Circle()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.brandPrimary.opacity(0.3))
                Text("\(user.name.prefix(1).uppercased())")
                    .foregroundStyle(.brandPrimary)
                    .font(.inter(.bold, size: 24))
            }
            VStack(alignment: .leading) {
                Text("\(user.name)")
                    .font(.inter(.bold, size: 24))
                Text(user.role.rawValue)
                    .foregroundStyle(.brandPrimary)
                    .font(.inter(.medium, size: 14))
                    .padding(.horizontal,12)
                    .padding(.vertical, 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.brandPrimary.opacity(0.2))
                            
                    }
            }
            Spacer()
        }
        
        .padding(24)
        .background(.surface)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        
    }
}
//#Preview {
//    ProfileHeaderView()
//}
