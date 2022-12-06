//
//  PostUITests.swift
//  Campus-ClosetUITests
//
//  Created by Amanda Peppard on 11/15/22.
//

import XCTest

class PostUITests: XCTestCase {

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
    
    func testPostFlow() throws{
        
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        
        let createPostButton = app.images["Add To Home Screen"]
        XCTAssertTrue(createPostButton.exists)
        createPostButton.tap()
        
        let choosePicButton = app.buttons["Choose a picture"]
        XCTAssertTrue(choosePicButton.exists)
        choosePicButton.tap()
        let testImage = app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, March 30, 2018, 2:14 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, March 30, 2018, 2:14 PM, Photo, August 08, 2012, 4:55 PM, Photo, August 08, 2012, 4:29 PM, Photo, August 08, 2012, 1:52 PM, Photo, October 09, 2009, 4:09 PM, Photo, March 12, 2011, 6:17 PM\"].images[\"Photo, March 30, 2018, 2:14 PM\"]",".images[\"Photo, March 30, 2018, 2:14 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        testImage.tap() //image needs to be selected before it populates page (i.e. "exists")
        XCTAssertTrue(testImage.exists)
        
        let nextButton = app.buttons["Next"]
        XCTAssertTrue(nextButton.exists)
        nextButton.tap()
        
        let itemNameField = app.staticTexts["Item Name*"]
        XCTAssertTrue(itemNameField.exists)
        itemNameField.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        

        let itemNameText = element.children(matching: .textField).element(boundBy: 0)
        itemNameText.tap()
        itemNameText.typeText("Test Item")
        
        let priceField = app.staticTexts["Price*"]
        XCTAssertTrue(priceField.exists)
        priceField.tap()
        let priceText = element.children(matching: .textField).element(boundBy: 1)
        priceText.typeText("5")
        
        let sizeField = app.staticTexts["Size*"]
        XCTAssertTrue(sizeField.exists)
        sizeField.tap()
        let sizeText = element.children(matching: .textField).element(boundBy: 2)
        sizeText.typeText("S")
        
        let conditionField = app.buttons["Condition*"]
        XCTAssertTrue(conditionField.exists)
        conditionField.tap()
        let newOption = app.collectionViews.buttons["New"]
        XCTAssertTrue(newOption.exists)
        newOption.tap()
        
        let description = app.staticTexts["Description"]
        XCTAssertTrue(description.exists)
        description.tap()
        let descriptionText = element.children(matching: .textField).element(boundBy: 3)
        descriptionText.tap()
        descriptionText.typeText("Test description")
        
        app.buttons["Done"].tap()
        element.buttons["Next"].tap()

        let postItemButton = app.buttons["Post Item!"]
        XCTAssertTrue(postItemButton.exists)
        postItemButton.tap()
   
        //assert that once item is posted, takes you back to profile
        let elementsQuery = app.scrollViews.otherElements
        //asserting these symbols exist indicate that the UI flow has navigated to profile page
        let venmoSign = elementsQuery.images["dollarsign.circle"]
        XCTAssertTrue(venmoSign.exists)
        let buyerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Buyer").element
        XCTAssertTrue(buyerButton.exists)
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        sellerButton.tap()
        
        //tapping first item in listings
        app.scrollViews.otherElements.containing(.image, identifier:"logo").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0).tap()
        
        //asserts that item that has been tapped is the item just posted
        //by asserting descriptive characteristics are the same
        XCTAssertTrue(app.staticTexts["Test Item"].exists)
        XCTAssertTrue(elementsQuery.staticTexts["Test description"].exists)
        XCTAssertTrue(elementsQuery.staticTexts["New"].exists)
                    
    }
    
    func testEditItemFlow() throws {
        let profileButton = app.tabBars["Tab Bar"].buttons["person"]
        profileButton.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let buyerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Buyer").element
        XCTAssertTrue(buyerButton.exists)
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        sellerButton.tap()
        
        //location in screen that represents first item in listings list
        let itemIcon = app.scrollViews.otherElements.containing(.image, identifier:"logo").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0)
        itemIcon.tap()

        
        let editItemButton = app.staticTexts["Edit Item"]
        XCTAssertTrue(editItemButton.exists)
        editItemButton.tap()
        
        app.staticTexts["Item Name*"].tap()
        
      
        app/*@START_MENU_TOKEN@*/.keys["delete"].press(forDuration: 1.6);/*[[".keyboards.keys[\"delete\"]",".tap()",".press(forDuration: 1.6);",".keys[\"delete\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        //when deleting and replacing text keyboard taps had to be entered
        //manually to work
        app.keys["T"].tap()
        app.keys["e"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()
        app.keys["space"].tap()
        app.buttons["shift"].tap()
        app.keys["E"].tap()
        app.keys["d"].tap()
        app.keys["i"].tap()
        app.keys["t"].tap()
        
        
        app/*@START_MENU_TOKEN@*/.buttons["done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Done"].tap()
        
        itemIcon.tap()
        //assert that the name of the top item has been changed to "Test Edit"
        XCTAssertTrue(app.staticTexts["Test Edit"].exists)
         
    }
    
    func testRemoveRequiredField() throws{
        let profileButton = app.tabBars["Tab Bar"].buttons["person"]
        profileButton.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let buyerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Buyer").element
        XCTAssertTrue(buyerButton.exists)
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        sellerButton.tap()
        
        //location in screen that represents first item in listings list
        let itemIcon = app.scrollViews.otherElements.containing(.image, identifier:"logo").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0)
        itemIcon.tap()

        
        let editItemButton = app.staticTexts["Edit Item"]
        XCTAssertTrue(editItemButton.exists)
        editItemButton.tap()
        
        app.staticTexts["Item Name*"].tap()
        
      
        app/*@START_MENU_TOKEN@*/.keys["delete"].press(forDuration: 1.6);/*[[".keyboards.keys[\"delete\"]",".tap()",".press(forDuration: 1.6);",".keys[\"delete\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        app/*@START_MENU_TOKEN@*/.buttons["done"]/*[[".keyboards",".buttons[\"done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Done"].tap()
        
        //assert error message shows
        let errorM = app.staticTexts["Please enter valid information for all required fields."]
        XCTAssertTrue(errorM.exists)
        
        //assert that interface remains on the edit item page
        XCTAssertTrue(app.staticTexts["Item Name*"].exists)
        XCTAssertTrue(app.staticTexts["Price*"].exists)
    }
    
    func testDeletePost() throws {
        //change numbers in "Listings" to reflect current number of listings
        //in test profile
        
        let profileButton = app.tabBars["Tab Bar"].buttons["person"]
        profileButton.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let buyerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Buyer").element
        XCTAssertTrue(buyerButton.exists)
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        sellerButton.tap()
        
        //change value to reflect current number of listings
        XCTAssertTrue(elementsQuery.buttons["Listings (3)"].exists)
        
        //location in screen that represents first item in listings list
        app.scrollViews.otherElements.containing(.image, identifier:"logo").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0).tap()

        
        let editItemButton = app.staticTexts["Edit Item"]
        XCTAssertTrue(editItemButton.exists)
        editItemButton.tap()
        let deleteItemButton = app.buttons["Delete Item"]
        XCTAssertTrue(deleteItemButton.exists)
        deleteItemButton.tap()
        app.alerts["Confirm Deletion"].scrollViews.otherElements.buttons["Delete"].tap()
        
        //assert that back in profile page
        XCTAssertTrue(buyerButton.exists)
        
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        homeButton.tap()
        profileButton.tap()
        sellerButton.tap()
        XCTAssertTrue(elementsQuery.buttons["Listings (2)"].exists)
        
    }

    func testPriceError() throws {
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        
        let createPostButton = app.images["Add To Home Screen"]
        XCTAssertTrue(createPostButton.exists)
        createPostButton.tap()
        
        let choosePicButton = app.buttons["Choose a picture"]
        XCTAssertTrue(choosePicButton.exists)
        choosePicButton.tap()
        let testImage = app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, March 30, 2018, 2:14 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, March 30, 2018, 2:14 PM, Photo, August 08, 2012, 4:55 PM, Photo, August 08, 2012, 4:29 PM, Photo, August 08, 2012, 1:52 PM, Photo, October 09, 2009, 4:09 PM, Photo, March 12, 2011, 6:17 PM\"].images[\"Photo, March 30, 2018, 2:14 PM\"]",".images[\"Photo, March 30, 2018, 2:14 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        testImage.tap() //image needs to be selected before it populates page (i.e. "exists")
        XCTAssertTrue(testImage.exists)
        
        let nextButton = app.buttons["Next"]
        XCTAssertTrue(nextButton.exists)
        nextButton.tap()
        
        let itemNameField = app.staticTexts["Item Name*"]
        XCTAssertTrue(itemNameField.exists)
        itemNameField.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        

        let itemNameText = element.children(matching: .textField).element(boundBy: 0)
        itemNameText.tap()
        itemNameText.typeText("Test Item Pricing Error")
        
        let priceField = app.staticTexts["Price*"]
        XCTAssertTrue(priceField.exists)
        priceField.tap()
        let priceText = element.children(matching: .textField).element(boundBy: 1)
        priceText.typeText("A")
        
        let sizeField = app.staticTexts["Size*"]
        XCTAssertTrue(sizeField.exists)
        sizeField.tap()
        let sizeText = element.children(matching: .textField).element(boundBy: 2)
        sizeText.typeText("S")
        
        let conditionField = app.buttons["Condition*"]
        XCTAssertTrue(conditionField.exists)
        conditionField.tap()
        let newOption = app.collectionViews.buttons["New"]
        XCTAssertTrue(newOption.exists)
        newOption.tap()
        
        let description = app.staticTexts["Description"]
        XCTAssertTrue(description.exists)
        description.tap()
        let descriptionText = element.children(matching: .textField).element(boundBy: 3)
        descriptionText.tap()
        descriptionText.typeText("Test pricing error")
        
        app.buttons["Done"].tap()
        element.buttons["Next"].tap()
        
        //asserting the error message is shown
        let errorM = app.staticTexts["Please enter valid information for all required fields."]
        XCTAssertTrue(errorM.exists)
        
        //asserting flow remains on same page
        XCTAssertTrue(itemNameField.exists)
        XCTAssertTrue(priceField.exists)
        XCTAssertTrue(sizeField.exists)

    
    }
    
    func testBlankFieldsError() throws {
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        homeButton.tap()
        
        let createPostButton = app.images["Add To Home Screen"]
        XCTAssertTrue(createPostButton.exists)
        createPostButton.tap()
        
        let choosePicButton = app.buttons["Choose a picture"]
        XCTAssertTrue(choosePicButton.exists)
        choosePicButton.tap()
        let testImage = app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, March 30, 2018, 2:14 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, March 30, 2018, 2:14 PM, Photo, August 08, 2012, 4:55 PM, Photo, August 08, 2012, 4:29 PM, Photo, August 08, 2012, 1:52 PM, Photo, October 09, 2009, 4:09 PM, Photo, March 12, 2011, 6:17 PM\"].images[\"Photo, March 30, 2018, 2:14 PM\"]",".images[\"Photo, March 30, 2018, 2:14 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        testImage.tap() //image needs to be selected before it populates page (i.e. "exists")
        XCTAssertTrue(testImage.exists)
        
        let nextButton = app.buttons["Next"]
        XCTAssertTrue(nextButton.exists)
        nextButton.tap()
        
        let itemNameField = app.staticTexts["Item Name*"]
        XCTAssertTrue(itemNameField.exists)
        itemNameField.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        

        let itemNameText = element.children(matching: .textField).element(boundBy: 0)
        itemNameText.tap()
        itemNameText.typeText("Test Item Blank Fields Error")
        
        let priceField = app.staticTexts["Price*"]
        XCTAssertTrue(priceField.exists)
        
        let sizeField = app.staticTexts["Size*"]
        XCTAssertTrue(sizeField.exists)
        
        app.buttons["Done"].tap()
        element.buttons["Next"].tap()
        
        //asserting the error message is shown
        let errorM = app.staticTexts["Please enter valid information for all required fields."]
        XCTAssertTrue(errorM.exists)
        
        //asserting flow remains on same page
        XCTAssertTrue(itemNameField.exists)
        XCTAssertTrue(priceField.exists)
        XCTAssertTrue(sizeField.exists)
        
                
    }
    
    func testCancelPost() throws {
        app.images["Add To Home Screen"].tap()
        app.buttons["Choose a picture"].tap()
        
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, October 09, 2009, 4:09 PM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, March 30, 2018, 2:14 PM, Photo, August 08, 2012, 4:55 PM, Photo, August 08, 2012, 4:29 PM, Photo, August 08, 2012, 1:52 PM, Photo, October 09, 2009, 4:09 PM, Photo, March 12, 2011, 6:17 PM\"].images[\"Photo, October 09, 2009, 4:09 PM\"]",".images[\"Photo, October 09, 2009, 4:09 PM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Next"].tap()
        
        
        let itemNameField = app.staticTexts["Item Name*"]
        XCTAssertTrue(itemNameField.exists)
        itemNameField.tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        

        let itemNameText = element.children(matching: .textField).element(boundBy: 0)
        itemNameText.tap()
        itemNameText.typeText("Test Cancel Post")
        
        
        app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"Back\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let homeButton = app.tabBars["Tab Bar"].buttons["Home"]
        XCTAssertTrue(homeButton.exists)
        
        let profileButton = app.tabBars["Tab Bar"].buttons["person"]
        XCTAssertTrue(profileButton.exists)
        profileButton.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let sellerButton = elementsQuery.segmentedControls.containing(.button, identifier:"Seller").element
        sellerButton.tap()
        
        //tapping first item in listings
        app.scrollViews.otherElements.containing(.image, identifier:"logo").children(matching: .other).element(boundBy: 0).children(matching: .button).element(boundBy: 0).tap()
        
        //asserts that item that has been canceled does not exist as most recent item
        XCTAssertFalse(app.staticTexts["Test Cancel Post"].exists)
      
    }
    
}

