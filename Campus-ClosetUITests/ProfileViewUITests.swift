//
//  ProfileViewUITests.swift
//  Campus-ClosetUITests
//
//  Created by Amanda Peppard on 11/10/22.
//  testing Profile View and Edit Profile View

import XCTest


class ProfileViewUITests: XCTestCase {

    private var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.

        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        app = nil
    }
    
    func testNavigateToProfile() throws{
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        let homeButton = tabBar.buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        let profileButton = tabBar.buttons["person"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        
        //Bids and Saved tabs are unique to the profile
        //Testing if they exist will assert that the app
        //Has sufficiently navigated back to the profile with no edits made
        let elementsQuery = app.scrollViews.otherElements
        let savedButton = elementsQuery.buttons["Saved"]
        XCTAssertTrue(savedButton.exists)
        savedButton.tap()
        let bidsButton = elementsQuery.buttons["Bids"]
        XCTAssertTrue(bidsButton.exists)
        bidsButton.tap()
        
    }

    func testEditProfile() throws {
        // UI tests must launch the application that they test.
        
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        let profileButton = tabBar.buttons["person"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        let editButton = app.scrollViews.otherElements.buttons["Edit"]
        XCTAssertTrue(editButton.exists)
        editButton.tap()
        let namebox = app.staticTexts["Name"]
        XCTAssertTrue(namebox.exists)
        namebox.tap()
        //namebox.typeText("Amanda Test 1")
        let window = app.children(matching: .window).element(boundBy: 0)
        let textField = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textField).element(boundBy: 0)
        textField.typeText("Amanda Test 1")
        let doneButton = window.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        let newName = app.scrollViews.otherElements.staticTexts["Amanda Test 1"]
        XCTAssertTrue(newName.exists)
    
    }
    
    func testEditProfileNoEdits() throws {
        let tabBar = app.tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        let profileButton = tabBar.buttons["person"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        let editButton = app.scrollViews.otherElements.buttons["Edit"]
        XCTAssertTrue(editButton.exists)
        editButton.tap()
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        
        //Bids and Saved tabs are unique to the profile
        //Testing if they exist will assert that the app
        //Has sufficiently navigated back to the profile with no edits made
        let elementsQuery = app.scrollViews.otherElements
        let savedButton = elementsQuery.buttons["Saved"]
        XCTAssertTrue(savedButton.exists)
        savedButton.tap()
        let bidsButton = elementsQuery.buttons["Bids"]
        XCTAssertTrue(bidsButton.exists)
        bidsButton.tap()
        
        let app = XCUIApplication()
        let emailTextField = app.textFields["email"]
        emailTextField.tap()
        emailTextField/*@START_MENU_TOKEN@*/.press(forDuration: 1.3);/*[[".tap()",".press(forDuration: 1.3);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        emailTextField/*@START_MENU_TOKEN@*/.press(forDuration: 0.9);/*[[".tap()",".press(forDuration: 0.9);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        emailTextField.tap()
        emailTextField.tap()
        app.collectionViews/*@START_MENU_TOKEN@*/.staticTexts["Paste"]/*[[".menuItems[\"Paste\"].staticTexts[\"Paste\"]",".staticTexts[\"Paste\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }
    
    func messAroundHere() throws {
        
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["person"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["Saved"].tap()
        elementsQuery.buttons["Bids"].tap()
        
        let elementsQuery2 = elementsQuery
        elementsQuery2/*@START_MENU_TOKEN@*/.buttons["Seller"]/*[[".segmentedControls.buttons[\"Seller\"]",".buttons[\"Seller\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        elementsQuery2/*@START_MENU_TOKEN@*/.buttons["Buyer"]/*[[".segmentedControls.buttons[\"Buyer\"]",".buttons[\"Buyer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
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
