//
//  ContentVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 10/31/22.
//

import XCTest
@testable import Campus_Closet

class ContentVMTests : XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor func testInitialization() {
        let contentVM = ContentVM()
        XCTAssertNotNil(contentVM, "The content view model should not be nil.")

    }
    
    @MainActor func testPreconditions(){
        let contentVM = ContentVM()
        XCTAssertEqual(contentVM.sortedColumns.count, 0, "sortedColumns should be empty")
        XCTAssertEqual(contentVM.tags.count, 0, "there should be no tags")
        for tag in contentVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "there should be no tags")
        }
    }
    
    @MainActor func testAddRemoveTag(){
        let contentVM = ContentVM()
        for tag in contentVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added yet")
        }
        contentVM.addTag(for: "womens")
        XCTAssertEqual(contentVM.tagsLeft["womens"], 0, "womens tag should be 0")
        for tag in contentVM.tagsLeft {
            if(tag.key != "womens"){
                XCTAssertEqual(tag.value, 1, "No tags besides womens should be 0")
            }
        }
        
        contentVM.removeTag(for: "womens")
        XCTAssertEqual(contentVM.tagsLeft["womens"], 1, "womens tag should be 1")
        for tag in contentVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be 0 now that womens tag removed")
        }
    }
    
    @MainActor func testFetchData() {
        let contentVM = ContentVM()
        XCTAssertNoThrow(contentVM.fetchData(), "This call should not throw an exception")
    }

}
