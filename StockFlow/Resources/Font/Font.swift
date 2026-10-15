//
//  Font.swift
//  ProductShopApp
//
//  Created by Cicek on 21.08.26.
//

import SwiftUI

extension Font {
    
    static func inter (_ weight: Inter, size: CGFloat) -> Font {
        custom(weight.rawValue, size: size)
    }
    
    enum Inter: String {
        case regular = "Inter24pt-Regular"
        case bold = "Inter24pt-Bold"
        case semiBold = "Inter24pt-SemiBold"
        case medium = "Inter28pt-Medium"
        case extraBold = "Inter28pt-ExtraBold"
    }
}
