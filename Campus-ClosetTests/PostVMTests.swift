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
    
    @MainActor func testUploadPicture(){
        let postVM = PostVM()
        XCTAssertNoThrow(postVM.uploadPicture(), "This call should not throw an exception")
        
        //TO DO:
        //test that picture successfully uploads
        //test that when picture size > max size, the proper error is thrown
        //test that when picture size < max size, program continues as normal
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
        postVM.postItem()
        XCTAssertEqual(postVM.tags.count, 0, "There should be no tags")
        XCTAssertFalse(postVM.isEditing, "isEditing flag should be false")
        XCTAssertFalse(postVM.sellerIsAnonymous, "sellerIsAnonymous flag should be false")
        XCTAssertNotNil(postVM.item._id, "item in ItemVM should not be nil")
        for tag in postVM.tagsLeft {
            XCTAssertEqual(tag.value, 1, "No tags should be added")
        }
    }
    
    //test in the process of being resolved
    @MainActor func testPostItem(){
        let postVM = PostVM()
        postVM.postItem()
        //let user = User()
        //let profileRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "0")
        //need some sort of call to Auth.auth().currentUser?.uid to get user and test if
        //they have an added listing
        //XCTAssertNotEqual(user.listings?.count, 0, "User should have at least one listing")
        //XCTAssertEqual(user.listings[listings.count - 1], "the id of the item just posted")
        
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
