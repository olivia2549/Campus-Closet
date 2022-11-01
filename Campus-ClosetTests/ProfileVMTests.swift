//
//  ProfileVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 10/31/22.
//

import XCTest
@testable import Campus_Closet

class ProfileVMTests : XCTestCase {
    
    var sut: ProfileVM!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testInitialization() {
        let user = User()
        
        
    }
    
    //need tests for:
    //profile shows the profile specified in the test
    //getProfileData
    //error handling for max size of an image
}
