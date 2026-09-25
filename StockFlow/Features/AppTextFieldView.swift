//
//  AppTextFieldView.swift
//  StockFlow
//
//  Created by Cicek on 22.09.26.
//

import SwiftUI

enum FocusedField: Hashable, CaseIterable {
    case name
    case email
    case password
    case phone
    case storeName
    case storeAddress
    case storePhone
}

struct AppTextFieldView: View {

    let title: String
    let placeholder: String
    let icon: String?
    let focusedField: FocusedField
    var errorMessage: String? = nil

    var textContentType: UITextContentType? = nil
    var keyboardType: UIKeyboardType = .default
    var submitLabel: SubmitLabel = .next
    var onSubmit: (() -> Void)? = nil

    @Binding var text: String

    var focusedFieldBinding: FocusState<FocusedField?>.Binding

    var body: some View {
        Section(title) {
            HStack(spacing: 8) {
                TextField(placeholder, text: $text)
                    .focused(
                        focusedFieldBinding,
                        equals: focusedField
                    )
                    .textContentType(textContentType)
                    .keyboardType(keyboardType)
                    .submitLabel(submitLabel)
                    .onSubmit {
                        onSubmit?()
                    }

                if let icon {
                    Image(systemName: icon)
                        .foregroundStyle(.iconSecondary)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1)
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        focusedFieldBinding.wrappedValue == focusedField
                        ? Color.accentColor
                        : Color.clear,
                        lineWidth: 1.5
                    )
            }
            
            if let errorMessage {
                Text(errorMessage)
                    .font(.inter(.regular, size: 12))
                                    .foregroundStyle(.red)
                                    .padding(.leading, 4)
            }
        }
    }
}
