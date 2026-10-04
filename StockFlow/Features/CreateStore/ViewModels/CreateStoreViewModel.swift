//
//  CreateStoreViewModel.swift
//  StockFlow
//
//  Created by Cicek on 23.09.26.
//

import Foundation

@MainActor
@Observable

final class CreateStoreViewModel {
    
    var state: CreateStoreViewState = .idle
    
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var phone: String = ""
    var storeName: String = ""
    var storePhone: String = ""
    var storeAddress: String = ""
    
    var fieldErrors: [CreateStoreFocusedField: String] = [:]
    
    private let storeRepository: StoreRepository
    
    init(storeRepository: StoreRepository) {
        self.storeRepository = storeRepository
    }
    
    func createStore() async {
        guard validateFields() else {
                return
            }
        
        state = .loading
        do {
            let response = try await storeRepository.createStore(
                name: name,
                email: email,
                password: password,
                phone: phone,
                storeName: storeName,
                storeAddress: storeAddress,
                storePhone: storePhone
            )
            state = .success(response)
        } catch  {
            state = .error(error.localizedDescription)
        }
    }
    
    
    private func validateFields() -> Bool {
        fieldErrors.removeAll()

        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.name] = "Full name is required."
        }

        if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.email] = "Email is required."
        } else if !email.contains("@") {
            fieldErrors[.email] = "Enter a valid email."
        }

        if password.isEmpty {
            fieldErrors[.password] = "Password is required."
        } else if password.count < 6 {
            fieldErrors[.password] = "Password must contain at least 6 characters."
        }

        if phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.phone] = "Phone is required."
        }

        if storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.storeName] = "Store name is required."
        }

        if storeAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.storeAddress] = "Store address is required."
        }

        if storePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fieldErrors[.storePhone] = "Store phone is required."
        }

        return fieldErrors.isEmpty
    }
}
