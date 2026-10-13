//
//  InfoRow.swift
//  StockFlow
//
//  Created by Cicek on 13.10.26.
//

import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title).foregroundStyle(.textSecondary)
            Spacer()
            Text(value).foregroundStyle(.textPrimary)
        }
    }
}
