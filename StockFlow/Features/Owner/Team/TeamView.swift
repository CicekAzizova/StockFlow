//
//  TeamView.swift
//  StockFlow
//
//  Created by Cicek on 04.10.26.
//

import SwiftUI

struct TeamView: View {
    
    @Binding  var path: NavigationPath
    @State var viewModel: TeamViewModel
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            VStack {
                header
                content
                
            }
            .padding()
        }
        .task {
            await viewModel.loadSalesAssociates()
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .idle:
            EmptyView()
            
        case .loading:
            ProgressView("Loading team...")
            
        case .loaded(let salesAssociates):
            if salesAssociates.isEmpty {
                ContentUnavailableView(
                    "No Team Members",
                    systemImage: "person.2",
                    description: Text("Add your first sales associate.")
                )
            } else {
                List {
                    teamStatsView
                        .listRowInsets(
                            EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)

                    Section {
                        ForEach(salesAssociates, id: \.id) { associate in
                            SalesAssociateInfoCardView(
                                name: associate.name,
                                surname: associate.surname,
                                todaySalesText: "Today's sales",
                                price: associate.totalSalesThisMonth
                            )
                            .listRowInsets(
                                EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .swipeActions(
                                edge: .trailing,
                                allowsFullSwipe: false
                            ) {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.deleteSalesAssociate(
                                            id: associate.id
                                        )
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            
        case .error(let message):
            ContentUnavailableView(
                "Something went wrong",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
    
   private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Team")
                    .font(.inter(.bold, size: 24))
                    .foregroundStyle(.textPrimary)
            }
            Spacer()
            Button {
                path.append(TeamRoute.addSalesAssociate)
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(.brandPrimary)
                    Image(systemName: "plus")
                        .font(.inter(.extraBold, size: 18))
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
   private var teamStatsView: some View {
        HStack {
            VStack {
                Text("\(viewModel.salesAssociateCount)")
                Text("Sales Associates")
            }
            
            Divider()
                .background(.divider)
            
            VStack {
                Text(viewModel.totalSales,
                     format: .currency(code: "USD").presentation(.isoCode))
                Text("Total Sales (This Month)")
            }
        }
        .foregroundStyle(.textPrimary)
        .padding()
        .frame(maxWidth: .infinity)
        .background(.success.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
        
}
