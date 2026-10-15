//
//  DismissKeyboardModifier.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import SwiftUI

extension View {
    func dismissKeyboardOnTap() -> some View {
        simultaneousGesture(
            TapGesture().onEnded {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
        )
    }
}
