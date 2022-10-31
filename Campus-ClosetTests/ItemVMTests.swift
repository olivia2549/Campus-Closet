//
//  ItemVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 10/31/22.
//

import XCTest
@testable import Campus_Closet

class ItemVMTests : XCTestCase {
    
    var sut: ItemVM!
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    var item = Item()
    func testInitialization() {
        
        XCTAssertNotNil(sut, "The item view should not be nil.")
        XCTAssertNotNil(item._id, "The item should have an id")

    }
    
    func testDataInput() {
        item.title = "Item 1"
        
        XCTAssertNotNil(item._id, "The item should have an ID")
        XCTAssertNotNil(item.title, "A title should be present")
        XCTAssertEqual(item.title, "Item 1", "The item title should match the input")

        
    }
    
    @MainActor func testFetchItem() {
        sut.fetchItem(with: item._id)
        
        //test image limit here
        
    }
    

}

