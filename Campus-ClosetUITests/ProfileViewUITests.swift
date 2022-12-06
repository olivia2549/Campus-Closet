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
        
        //Buyer and Seller tabs are unique to the profile
        //Testing if they exist will assert that the app
        //Has sufficiently navigated back to the profile with no edits made
        let elementsQuery = app.scrollViews.otherElements
        let buyerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Buyer").element
        XCTAssertTrue(buyerButton.exists)
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        XCTAssertTrue(sellerButton.exists)
        sellerButton.tap()
        buyerButton.tap()
        
    }
/*
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
        namebox.typeText("Amanda Test 1")
        //let textField = app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element

        //textField.tap()
        app.windows.keys["delete"].press(forDuration: 5)
        //textField.typeText("Amanda Test 1")
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.exists)
        doneButton.tap()
        let newName = app.scrollViews.otherElements.staticTexts["Amanda Test 1"]
        XCTAssertTrue(newName.exists)
        
        /*
        let app = XCUIApplication()
        app.tabBars["Tab Bar"].buttons["person"].tap()
        app.scrollViews.otherElements.buttons["Edit"].tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".keyboards.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
*/
    
    }
  */
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
        
        //Buyer and Seller tabs are unique to the profile
        //Testing if they exist will assert that the app
        //Has sufficiently navigated back to the profile with no edits made
        let elementsQuery = app.scrollViews.otherElements
        let buyerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Buyer").element
        XCTAssertTrue(buyerButton.exists)
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        XCTAssertTrue(sellerButton.exists)
        sellerButton.tap()
        buyerButton.tap()
        
        
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
