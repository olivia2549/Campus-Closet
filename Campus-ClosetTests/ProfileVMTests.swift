//
//  ProfileVMTests.swift
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

class ProfileVMTests : XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor func testInitialization() {
        let profileVM = ProfileVM()
        XCTAssertNotNil(profileVM, "The profile view model should not be nil.")
        
    }
    
    @MainActor func testPreconditions(){
        let profileVM = ProfileVM()
        XCTAssertNotNil(profileVM.user, "User should exist")
        XCTAssertEqual(profileVM.numRatings, 0, "numRatings should be 0")
        XCTAssertEqual(profileVM.averageRating, 0.0, "averageRating should be 0.0")
        XCTAssertEqual(profileVM.sortedColumns.count, 0, "sortedColumns array should be empty")
    }
    
    @MainActor func testGetProfileData(){
        let profileVM = ProfileVM()
        XCTAssertNoThrow(profileVM.getProfileData(), "This call should not throw an exception")
        //TO DO: test error handling on max size of an image
    }
    
    @MainActor func testFetchUser(){
        let profileVM = ProfileVM()
        XCTAssertNoThrow(profileVM.fetchUser(userID: Auth.auth().currentUser?.uid ?? "0"), "This call should not throw an exception")
        profileVM.fetchUser(userID: Auth.auth().currentUser?.uid ?? "0")
        XCTAssertNotNil(profileVM.user, "User should be fetched and exist")
    }
    
}
