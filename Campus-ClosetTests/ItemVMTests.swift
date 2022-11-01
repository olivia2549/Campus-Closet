//
//  ItemVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 10/31/22.
//

import XCTest
@testable import Campus_Closet

class ItemVMTests : XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor func testInitialization() {
        let itemVM = ItemVM()
        XCTAssertNotNil(itemVM, "The item view should not be nil.")
        XCTAssertNotNil(itemVM.item._id, "The item should have an id")

    }
    
    @MainActor func testPreconditions(){
        let itemVM = ItemVM()
        XCTAssertTrue(itemVM.isEditing, "isEditing flag should be true")
        XCTAssertFalse(itemVM.isSeller, "isSeller flag should be false")
    }
    
    @MainActor func testItemPreconditions(){
        let itemVM = ItemVM()
        XCTAssertNotNil(itemVM.item._id, "item in ItemVM should not be nil")
        XCTAssertEqual(itemVM.item.title, "", "title should be initialized as an empty string")
        XCTAssertEqual(itemVM.item.picture, "", "picture should be initialized as an empty string")
        XCTAssertEqual(itemVM.item.description, "", "description should be initialized as an empty string")
        XCTAssertEqual(itemVM.item.sellerId, "", "sellerId should be initialized as an empty string")
        XCTAssertEqual(itemVM.item.price, "", "price should be initialized as an empty string")
        XCTAssertEqual(itemVM.item.size, "", "size should be initialized as an empty string")
        XCTAssertEqual(itemVM.item.condition, "", "condition should be initialized as an empty string")
        XCTAssertTrue(itemVM.item.biddingEnabled, "biddingEnabled flag should be true")
        XCTAssertEqual(itemVM.item.tags?.count, 0, "no tags should be added")
    }
    
    @MainActor func testDataInput() {
        let itemVM = ItemVM()
        itemVM.item.title = "Item 1"
        
        XCTAssertNotNil(itemVM.item._id, "The item should have an ID")
        XCTAssertNotNil(itemVM.item.title, "A title should be present")
        XCTAssertEqual(itemVM.item.title, "Item 1", "The item title should match the input")
        
    }
    
    @MainActor func testFetchItem() {
        let itemVM = ItemVM()
        XCTAssertNoThrow(itemVM.fetchItem(with: itemVM.item._id), "This call should not throw an exception")
        
        //asserting preconditions have been maintained after fetchItem
        itemVM.fetchItem(with: itemVM.item._id)
        XCTAssertTrue(itemVM.isEditing, "isEditing flag should be true")
        XCTAssertFalse(itemVM.isSeller, "isSeller flag should be false")
    }
    

}

