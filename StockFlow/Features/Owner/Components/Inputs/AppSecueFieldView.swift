//
//  AppSecueFieldView.swift
//  StockFlow
//
//  Created by Cicek on 22.09.26.
//

import SwiftUI

struct AppSecureFieldView<FocusedField: Hashable>: View {
    
    let placeholder: String
    let focusedField: FocusedField?
    var errorMessage: String? = nil
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil
    
    @Binding var text: String
    
    var focusedFieldBinding: FocusState<FocusedField?>.Binding//focsun hansinda oldugunu oxuyur
    
    @State private var isAppear = false
    
    var body: some View {
        Section("Password") {
            
            HStack(spacing: 8) {
                
                Group {
                    if isAppear {
                        TextField(placeholder, text: $text)
                    } else {
                        SecureField(placeholder, text: $text)
                    }
                }
                .focused(
                    focusedFieldBinding,
                    equals: focusedField
                )
                .textContentType(.password)
                .submitLabel(submitLabel)
                .onSubmit {
                    onSubmit?()
                }
                .foregroundStyle(.textPrimary)
                
                Button {
                    isAppear.toggle()
                } label: {
                    Image(
                        systemName: isAppear
                        ? "eye.slash"
                        : "eye"
                    )
                    .foregroundStyle(.icon)
                }
            }
            
            .padding(.horizontal, 12)
            .frame(height: 44)
            .background(.border)
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
            .clipShape(RoundedRectangle(cornerRadius: 12))
            if let errorMessage {
                Text(errorMessage)
                    .font(.inter(.regular, size: 12))
                    .foregroundStyle(.error)
                    .padding(.leading, 4)
            }
        }
    }
}
