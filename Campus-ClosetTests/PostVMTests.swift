//
//  PostVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 10/31/22.
//

import XCTest
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
@testable import Campus_Closet

class PostVMTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    let db = Firestore.firestore()
    @MainActor func testCreation() {
        let postVM = PostVM()
        let item = Item()
        XCTAssertNotNil(postVM, "The item view should not be nil.")
        XCTAssertNotNil(item._id, "The item should have an id")
        
    }
    
    
    @MainActor func testPreconditions(){
        let postVM = PostVM()
        XCTAssertEqual(postVM.tags.count, 0, "There should be no tags")
        XCTAssertFalse(postVM.isEditing, "isEditing flag should be false")
        XCTAssertFalse(postVM.sellerIsAnonymous, "sellerIsAnonymous flag should be false")
        XCTAssertNotNil(postVM.item._id, "item in ItemVM should not be nil")
        for tag in postVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added")
        }
    }
    
    @MainActor func testPostConditions(){
        //after postItem is called, no preconditions should be changed
        let postVM = PostVM()
        XCTAssertEqual(postVM.tags.count, 0, "There should be no tags")
        XCTAssertFalse(postVM.isEditing, "isEditing flag should be false")
        XCTAssertFalse(postVM.sellerIsAnonymous, "sellerIsAnonymous flag should be false")
        XCTAssertNotNil(postVM.item._id, "item in ItemVM should not be nil")
        for tag in postVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added")
        }
        postVM.postItem() { _ in return }
        XCTAssertEqual(postVM.tags.count, 0, "There should be no tags")
        XCTAssertFalse(postVM.isEditing, "isEditing flag should be false")
        XCTAssertFalse(postVM.sellerIsAnonymous, "sellerIsAnonymous flag should be false")
        XCTAssertNotNil(postVM.item._id, "item in ItemVM should not be nil")
        for tag in postVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added")
        }
    }
    
    @MainActor func testAddRemoveTag(){
        let postVM = PostVM()
        for tag in postVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added yet")
        }
        postVM.addTag(for: "womens")
        XCTAssertEqual(postVM.tagsLeft["womens"], 0, "womens tag should be 0")
        for tag in postVM.tagsLeft {
            if(tag.key != "womens"){
                XCTAssertEqual(tag.value, 1, "No tags besides womens should be 0")
            }
        }
        
        postVM.removeTag(for: "womens")
        XCTAssertEqual(postVM.tagsLeft["womens"], 1, "womens tag should be 1")
        for tag in postVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be 0 now that womens tag removed")
        }
    }

    
    

}
