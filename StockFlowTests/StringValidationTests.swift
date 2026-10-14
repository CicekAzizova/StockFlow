//
//  StringValidationTests.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import Testing
@testable import StockFlow

@MainActor
struct StringValidationTests {

    @Test(arguments: ["a@b.co", "owner@stockflow.com", "x.y+z@mail.example.org"])
    func validEmails(_ email: String) {
        #expect(email.isValidEmail)
    }

    @Test(arguments: ["", "plain", "a@b", "a b@c.com", "@c.com"])
    func invalidEmails(_ email: String) {
        #expect(!email.isValidEmail)
    }

    @Test(arguments: ["", "   ", "\n\t"])
    func blankStrings(_ text: String) {
        #expect(text.isBlank)
    }

    @Test func nonBlankString() {
        #expect(!"a".isBlank)
    }

    @Test func decimalParsingAcceptsCommaAndDot() {
        #expect("12,5".asDecimal == 12.5)
        #expect(" 7.25 ".asDecimal == 7.25)
        #expect("abc".asDecimal == nil)
    }
}
