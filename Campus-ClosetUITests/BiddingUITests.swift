//
//  BiddingUITests.swift
//  Campus-ClosetUITests
//
//  Created by Amanda Peppard on 11/15/22.
//

import XCTest



class BiddingUITests: XCTestCase {

    private var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testBiddingFlow() throws {
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        let item = app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 2)
        item.tap()
        
        let bidButton = app.buttons["Place Bid"]
        XCTAssert(bidButton.exists)
        bidButton.tap()
        
        let bidField = app.textFields["0"]
        XCTAssert(bidField.exists)
        bidField.tap()
        bidField.typeText("50")
        
        let sendBid = app.buttons["Send Bid Offer"]
        XCTAssert(sendBid.exists)
        sendBid.tap()
        
        //assert bid is successfully placed
        //i.e., go to profile and find bid under "Bids"
    
    }
    
    func testNoBidEntry() throws {
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        let item = app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 2)
        item.tap()
        
        let bidButton = app.buttons["Place Bid"]
        XCTAssert(bidButton.exists)
        bidButton.tap()
        
        let bidField = app.textFields["0"]
        XCTAssert(bidField.exists)
        bidField.tap()
        
        let sendBid = app.buttons["Send Bid Offer"]
        XCTAssert(sendBid.exists)
        sendBid.tap()
        //assert that error message shows up
        
    }
    
    

    func testIncorrectValueEntry() throws{
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        let item = app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 2)
        item.tap()
        
        let bidButton = app.buttons["Place Bid"]
        XCTAssert(bidButton.exists)
        bidButton.tap()
        
        let bidField = app.textFields["0"]
        XCTAssert(bidField.exists)
        bidField.tap()
        bidField.typeText("A")
        
        let sendBid = app.buttons["Send Bid Offer"]
        XCTAssert(sendBid.exists)
        sendBid.tap()
        
        //assert error message shows up
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
