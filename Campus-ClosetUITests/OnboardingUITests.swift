//
//  OnboardingUITests.swift
//  Campus-ClosetUITests
//
//  Created by Amanda Peppard on 11/10/22.
//

import XCTest



class OnboardingUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSignupTextEntry() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append("Testing")
        app.launch()
        
        let signUpButton = app.buttons["Sign Up"]
        signUpButton.tap()
        app.textFields["email"].tap()
        
        let passwordSecureTextField = app.secureTextFields["password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.tap()
        signUpButton.tap()
        app.buttons["Done"].tap()
        //Assert that "verification screen" elements exist
                        
    }
    
    func testLogin() throws {
        let app = XCUIApplication()
        app.launchArguments = ["testing"]
        app.launch()
        
        let email = app.textFields["email"]
        XCTAssertTrue(email.exists)
        email.tap()
        email.typeText("amanda.r.peppard@vanderbilt.edu")

        let passwordSecureTextField = app.secureTextFields["password"]
        XCTAssertTrue(passwordSecureTextField.exists)
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("pianorocks1")

        
        let logInButton = app.buttons["Log In"]
        XCTAssertTrue(logInButton.exists)
        logInButton.tap()
        let okButton = app.buttons["OK"]
        XCTAssertTrue(okButton.exists)
        okButton.tap()
        //passwordSecureTextField.tap()
        //logInButton.tap()
    
        
        //let message = app.staticTexts["Test!"]
        //XCTAssertTrue(message.waitForExistence(timeout: 5))
                        
    }
    
    func testLogin2(){
        
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
