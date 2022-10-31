//
//  PostVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 10/31/22.
//

import XCTest
@testable import Campus_Closet

class PostVMTests : XCTestCase {
    
    var sut: PostVM!
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testCreation() {
        var item = Item()
        XCTAssertNotNil(sut, "The item view should not be nil.")
        XCTAssertNotNil(item._id, "The item should have an id")
        
    }
    
    func testUploadPicture(){
        //test that picture successfully uploads
        //test that when picture size > max size, the proper error is thrown
        //test that when picture size < max size, program continues as normal
    }
    
    @MainActor func testPostItem(){
        var user = User()
        user.name = "Test User"
        sut.postItem()
        XCTAssertNotEqual(user.listings?.count, 0, "User should have at least one listing")
        //XCTAssertEqual(user.listings[0], "the id of the item just posted")
        
    }
    
    @MainActor func testAddRemoveTag(){
        for tag in sut.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added yet")
        }
        sut.addTag(for: "womens")
        XCTAssertEqual(sut.tagsLeft["womens"], 0, "womens tag should be 0")
        for tag in sut.tagsLeft {
            if(tag.key != "womens"){
                XCTAssertEqual(tag.value, 1, "No tags besides womens should be 0")
            }
        }
        
        sut.removeTag(for: "womens")
        XCTAssertEqual(sut.tagsLeft["womens"], 1, "womens tag should be 1")
        for tag in sut.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be 0 now that womens tag removed")
        }
    }
    
    

}
