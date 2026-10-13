//
//  HomeSummaryGrid.swift
//  StockFlow
//
//  Created by Cicek on 08.10.26.
//
import SwiftUI

struct HomeSummaryGrid: View {

    let todaySales: Double
    let totalSales: Double
    let productsCount: Int
    let lowStockCount: Int
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            GridRow {
                SummaryGridView(
                    title: "Today's sales",
                    value: todaySales.asCurrency,
                    icon: "chart.bar",
                    iconColor: .brandPrimary
                )

                SummaryGridView(
                    title: "Revenue",
                    value: totalSales.asCurrency,
                    icon: "dollarsign.circle",
                    iconColor: .success
                )
            }

            GridRow {
                SummaryGridView(
                    title: "Total products",
                    value: "\(productsCount)",
                    icon: "cube",
                    iconColor: .brandPrimary
                )

                SummaryGridView(
                    title: "Low stock",
                    value: "\(lowStockCount)",
                    icon: "exclamationmark.triangle",
                    iconColor: .warning
                )
            }
        }
    }
}
