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
        //precondition: there are zero bids currently in the profile
        //if bids need to stay, change line 39 to reflect current number of bids
        //and line 72 to one higher than the current number of bids
        let profileButton = app.tabBars["Tab Bar"].buttons["person"]
        profileButton.tap()
        //asserting there are currently 0 bids listed in the profile
        XCTAssertTrue(app.scrollViews.otherElements.buttons["Bids (0)"].exists)
        XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Nothing to show"].exists)
        
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        homeButton.tap()
        
        //item is a specific point on the screen - if an error is thrown when asserting
        //bidButton exists, it likely did not click on a specific item
        //to resolve, try changing boundBy value to reference different point on the screen
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
        
        //assert pop up message shows up
        XCTAssertTrue(app.staticTexts["Thanks for your purchase!"].exists)
        app.buttons["OK"].tap()
        
        homeButton.tap()
        profileButton.tap()
        
        //assert bid is successfully placed
        //i.e., go to profile and assert that there is now 1 bid instead of 0
    
        //there should be 1 bid present (or 1 + current # of bids)
        XCTAssertTrue(app.scrollViews.otherElements.buttons["Bids (1)"].exists)
        //there should be an icon to represent the item bidded instead of "Nothing to show"
        XCTAssertFalse(app.scrollViews.otherElements.staticTexts["Nothing to show"].exists)
    
    }

    
    func testNoBidEntry() throws {
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        let item = app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 2)
        item.tap()
        
        let bidButton = app.buttons["Place Bid"]
        XCTAssertTrue(bidButton.exists)
        bidButton.tap()
        
        let bidField = app.textFields["0"]
        XCTAssertTrue(bidField.exists)
        bidField.tap()
        
        let sendBid = app.buttons["Send Bid Offer"]
        XCTAssertTrue(sendBid.exists)
        sendBid.tap()
        //assert that error message shows up
        
        let errorM = app.staticTexts["Oops! There has been a problem placing your bid. Your bid price may be lower than the current listed price."]
        XCTAssertTrue(errorM.exists)
        app.buttons["OK"].tap()
        //"Make an offer" static text is unique to bid entry page
        // asserting it exists helps indicate the UI remained on the same page
        // to await reentry or exit of the bidding page
        XCTAssertTrue(app.staticTexts["Make an offer"].exists)
        
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
        let errorM = app.staticTexts["Oops! There has been a problem placing your bid. Your bid price may be lower than the current listed price."]
        XCTAssertTrue(errorM.exists)
        app.buttons["OK"].tap()
        //"Make an offer" static text is unique to bid entry page
        // asserting it exists helps indicate the UI remained on the same page
        // to await reentry or exit of the bidding page
        XCTAssertTrue(app.staticTexts["Make an offer"].exists)
    }
    
    func testOutOfRangeEntry() throws{
        app.tabBars["Tab Bar"].buttons["Home"].tap()
        
        let item = app.scrollViews.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 2)
        item.tap()
        
        let bidButton = app.buttons["Place Bid"]
        XCTAssert(bidButton.exists)
        bidButton.tap()
        
        let bidField = app.textFields["0"]
        XCTAssert(bidField.exists)
        bidField.tap()
        bidField.typeText("2")
        
        let sendBid = app.buttons["Send Bid Offer"]
        XCTAssert(sendBid.exists)
        sendBid.tap()
        
        //assert error message shows up
        let errorM = app.staticTexts["Oops! There has been a problem placing your bid. Your bid price may be lower than the current listed price."]
        XCTAssertTrue(errorM.exists)
        app.buttons["OK"].tap()
        //"Make an offer" static text is unique to bid entry page
        // asserting it exists helps indicate the UI remained on the same page
        // to await reentry or exit of the bidding page
        XCTAssertTrue(app.staticTexts["Make an offer"].exists)
    }
    

    func testRemoveBid() throws {
        //precondition: there is exactly 1 bid currently in the profile
        
        let profileButton = app.tabBars["Tab Bar"].buttons["person"]
        profileButton.tap()
        //asserting there are currently 0 bids listed in the profile
        XCTAssertFalse(app.scrollViews.otherElements.buttons["Bids (0)"].exists)
        XCTAssertFalse(app.scrollViews.otherElements.staticTexts["Nothing to show"].exists)
        
        //tap area where first item in bid list would be located
        app.scrollViews.otherElements.containing(.image, identifier:"logo").element.tap()
        app.scrollViews.otherElements.containing(.image, identifier:"logo").children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
        
        let removeBid = app.buttons["Remove Bid"]
        //remove bid button is unique to this page, asserting that in detail view
        //of the item
        XCTAssertTrue(removeBid.exists)
        removeBid.tap()
        
        //assert that once bid is removed, takes you back to profile
        let elementsQuery = app.scrollViews.otherElements
        //asserting this symbol exists indicates that the UI flow has navigated to profile page
        let venmoSign = elementsQuery.images["dollarsign.circle"]
        XCTAssertTrue(venmoSign.exists)
       
        
        //assert that bid hasbeen removed from the profile
        XCTAssertTrue(app.scrollViews.otherElements.buttons["Bids (0)"].exists)
        XCTAssertTrue(app.scrollViews.otherElements.staticTexts["Nothing to show"].exists)
      
    }
}
