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
        
        let tabBar = XCUIApplication().tabBars["Tab Bar"]
        XCTAssertTrue(tabBar.exists)
        let homeButton = tabBar.buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        let profileButton = tabBar.buttons["person"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        //test buttons/text found in "Profile View" exist
        
    }

    func testEditProfile() throws {
        // UI tests must launch the application that they test.
        
        app.tabBars["Tab Bar"].buttons["person"].tap()
        app.scrollViews.otherElements.buttons["Edit"].tap()
        let namebox = app.textFields["Name"]
        namebox.typeText("Amanda Test")
        app.buttons["Done"].tap()
        //XCTAssertEqual()
        
        
        
                        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
