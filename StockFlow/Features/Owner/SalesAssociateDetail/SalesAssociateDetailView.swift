////
////  SalesAssociateDetail.swift
////  StockFlow
////
////  Created by Cicek on 05.10.26.
////
//
//import SwiftUI
//
//struct SalesAssociateDetailView: View {
//    
//    @State var viewModel: SalesAssociateDetailViewModel
//    
//    let associateId: Int
//
//    init(viewModel: SalesAssociateDetailViewModel, associateId: Int) {
//        self._viewModel = State(initialValue: viewModel)
//        self.associateId = associateId
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.background
//                .ignoresSafeArea()
//            
//            content
//        }
//        .navigationTitle("Sales Associate")
//        .navigationBarTitleDisplayMode(.inline)
//        .task {
//            await viewModel.loadSalesAssociate(id: associateId)
//        }
//    }
//    
//    @ViewBuilder
//    var content: some View {
//        switch viewModel.state {
//        case .idle, .loading:
//            ProgressView()
//        case .loaded(let associate):
//                detailView(associate: associate)
//        case .error(let message):
//            ContentUnavailableView {
//                Label(
//                    "Something went wrong",
//                    systemImage: "exclamationmark.triangle"
//                )
//            } description: {
//                Text(message)
//            }
//        }
//    }
//    
//    private func detailView(
//            associate: SalesAssociateDetailResponse
//        ) -> some View {
//            ScrollView {
//                VStack(spacing: 20) {
//
//                    VStack(spacing: 12) {
//                        Image(systemName: "person.circle.fill")
//                            .font(.system(size: 70))
//                            .foregroundStyle(.brandPrimary)
//
//                        Text("Sales Associate")
//                            .font(.inter(.bold, size: 20))
//                    }
//
//                    
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Personal Information")
//                            .font(.inter(.bold, size: 18))
//
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(.white)
//                    .clipShape(
//                        RoundedRectangle(cornerRadius: 16)
//                    )
//                }
//                .padding()
//            }
//        }
//}
