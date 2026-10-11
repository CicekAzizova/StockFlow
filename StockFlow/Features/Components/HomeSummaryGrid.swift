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

    var body: some View {
        Grid(
            horizontalSpacing: 16,
            verticalSpacing: 16
        ) {
            GridRow {
                SummaryGridView(
                    title: "Today's sales",
                    value: "\(todaySales)",
                    icon: "chart.bar",
                    iconColor: .brandPrimary
                )

                SummaryGridView(
                    title: "Revenue",
                    value: "\(totalSales)",
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
