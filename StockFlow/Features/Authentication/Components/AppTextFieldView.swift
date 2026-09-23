//
//  AppTextFieldView.swift
//  StockFlow
//
//  Created by Cicek on 22.09.26.
//

import SwiftUI

enum FocusedField: Hashable , CaseIterable {
    case email
    case password
}

import SwiftUI

struct AppTextFieldView: View {

    let title: String
    let placeholder: String
    let icon: String?
    let focusedField: FocusedField

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
                    .stroke(
                        focusedFieldBinding.wrappedValue == focusedField
                        ? Color.accentColor
                        : Color.clear,
                        lineWidth: 1.5
                    )
            }
        }
    }
}
