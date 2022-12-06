//
//  ContentUITests.swift
//  Campus-ClosetUITests
//
//  Created by Amanda Peppard on 11/10/22.
//

import XCTest


class ContentUITests: XCTestCase {

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
    
    func testProfileView() throws{
        //tapping on an item
        app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0).tap()
        
        let profileButton = app.buttons["Lauren, @Le-scott, 0.00 (0 Ratings)"]
        profileButton.tap()
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        
        //asserting certain buttons associated with profile view are present
        //to ascertain we are viewing a profile
        XCTAssertTrue(elementsQuery.images["Favorite"].exists)
        XCTAssertTrue(elementsQuery.images["dollarsign.circle"].exists)
                
    
    }

    func testFilter() throws {
        
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        app.buttons["All"].tap()
        app.collectionViews.buttons["womens"].tap()
        
        XCTAssertTrue(app.staticTexts["womens"].exists)
        app.staticTexts["womens"].tap()
        XCTAssertFalse(app.staticTexts["womens"].exists)
        
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
