//
//  HowToUITests.swift
//  HowToUITests
//
//  Created by Tobi Kuyoro on 01/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import XCTest

class HowToUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Properties

    private var addButton: XCUIElement {
        return app.navigationBars["Guides"].buttons["Add"]
    }

    private var usernameTextField: XCUIElement {
        return app.textFields["Username"]
    }

    private var passwordTextField: XCUIElement {
        return app.secureTextFields["Password"]
    }

    private var signInButton: XCUIElement {
        return app.buttons["SIGN IN"]
    }

    private var signUpButton: XCUIElement {
        return app.buttons["SIGN UP"]
    }

    private var returnButton: XCUIElement {
        return app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards.buttons[\"Return\"]",".buttons[\"Return\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    }

    private var registerButton: XCUIElement {
        return app.buttons["Register"]
    }

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["Testing"]
        app.launch()
    }

    func testTappingFirstCellAndGoingBackToHomScreen() {
        let homeHowToTestYourWorkCell = app.tables.cells["Home, How To Test Your Work"]
        homeHowToTestYourWorkCell.children(matching: .image).element.tap()
        let backButton = app.navigationBars["HowTo.TutorialDetailView"].buttons["Back"]
        backButton.tap()
    }

    func testLoggingIn() {
        addButton.tap()
        usernameTextField.tap()
        usernameTextField.tap()
        usernameTextField.typeText("iOSTest1\n")
        passwordTextField.tap()
        passwordTextField.typeText("password")
        returnButton.tap()
        signInButton.tap()

        let expectation = XCTestExpectation(description: "Waiting for sign in")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testAttemptToEditTutorial() {

       addButton.tap()
       usernameTextField.tap()
       usernameTextField.tap()
       usernameTextField.typeText("iOSTest1\n")
       passwordTextField.tap()
       passwordTextField.typeText("password")
       returnButton.tap()
       signInButton.tap()

       let expectation = XCTestExpectation(description: "Waiting for sign in")
       DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           expectation.fulfill()
       }

       wait(for: [expectation], timeout: 5)
        
        let howtoCreatetutorialviewNavigationBar = app.navigationBars["HowTo.CreateTutorialView"]
        howtoCreatetutorialviewNavigationBar.buttons["Back"].tap()
        app.tables.cells["Home, How To Test Your Work"].children(matching: .image).element.tap()
        app.navigationBars["HowTo.TutorialDetailView"].buttons["Edit"].tap()
        app.children(matching: .window).element(boundBy: 0)
            .children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .other)
            .element.children(matching: .textView)
            .element.tap()
        app.typeText("edit")
        howtoCreatetutorialviewNavigationBar.buttons["Save"].tap()
    }

    func testRegisteringUser() {
        addButton.tap()
        app.buttons["Register"].tap()
        usernameTextField.tap()
        usernameTextField.tap()
        usernameTextField.typeText("iOSTest1\n")
        passwordTextField.tap()
        passwordTextField.typeText("password")
        returnButton.tap()
        signUpButton.tap()

        let expectation = XCTestExpectation(description: "Waiting for sign in")
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }
}