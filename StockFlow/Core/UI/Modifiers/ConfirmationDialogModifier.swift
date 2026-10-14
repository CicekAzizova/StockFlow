//
//  ConfirmationDialogModifier.swift
//  StockFlow
//
//  Created by Cicek on 14.10.26.
//

import SwiftUI

struct ConfirmationDialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    let title: String
    let message: String?
    let confirmTitle: String
    let role: ButtonRole?
    let onConfirm: () -> Void
    
    func body(content: Content) -> some View {
        content.confirmationDialog(title, isPresented: $isPresented, titleVisibility: .visible) {
            
            Button(confirmTitle, role: role) {
                onConfirm()
            }
            
            Button("Cancel", role: .cancel) {
            }
        } message: {
            if let message {
                Text(message)
            }
        }
    }
}

extension View {
    
    func confirmationDialog(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        confirmTitle: String,
        role: ButtonRole? = .destructive,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(
            ConfirmationDialogModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmTitle: confirmTitle,
                role: role,
                onConfirm: onConfirm
            )
        )
    }
}
