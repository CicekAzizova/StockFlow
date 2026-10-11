////
////  SalesAssociateDetailViewModel.swift
////  StockFlow
////
////  Created by Cicek on 06.10.26.
////
//import Foundation
//
//@Observable
//@MainActor
//
//final class SalesAssociateDetailViewModel {
//    
//    private let repository: SalesAssociateRepository
//
//    var state: SalesAssociateDetailViewState =  .idle
//    
//    init(repository: SalesAssociateRepository) {
//        self.repository = repository
//    }
//    
//    func loadSalesAssociate(id: Int) async {
//        state = .loading
//        do {
//            let detail = try await repository.deleteSalesAssociate(id: id)
//            state = .loaded(detail)
//        }
//        catch {
//            state = .error(error.localizedDescription)
//        }
//    }
//}
