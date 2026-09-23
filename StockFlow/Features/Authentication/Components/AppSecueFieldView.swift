//
//  AppSecueFieldView.swift
//  StockFlow
//
//  Created by Cicek on 22.09.26.
//

import SwiftUI

struct AppSecureFieldView: View {
    
    let placeholder: String
    let focusedField: FocusedField
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil
    
    @Binding var text: String
    
    var focusedFieldBinding: FocusState<FocusedField?>.Binding
    
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
                
                Button {
                    isAppear.toggle()
                } label: {
                    Image(
                        systemName: isAppear
                        ? "eye.slash"
                        : "eye"
                    )
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
