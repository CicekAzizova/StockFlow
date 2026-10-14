//
//  LoginUITests.swift
//  StockFlow
//
//  Created by Cicek on 15.10.26.
//

import XCTest

final class LoginUITests: XCTestCase {

    private var app: XCUIApplication!

    @MainActor
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLoginScreenShowsFormElements() {
        XCTAssertTrue(app.staticTexts["Welcome back"].waitForExistence(timeout: 10))
        XCTAssertTrue(app.textFields["loginEmailField"].exists)
        XCTAssertTrue(app.secureTextFields["loginPasswordField"].exists)
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }

    @MainActor
    func testEmptyFormShowsValidationErrors() {
        let signInButton = app.buttons["Sign In"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 10))

        signInButton.tap()

        XCTAssertTrue(app.staticTexts["Email is required."].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Password is required."].exists)
    }
}
