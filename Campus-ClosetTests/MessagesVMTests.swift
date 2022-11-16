//
//  MessagesVMTests.swift
//  Campus-ClosetTests
//
//  Created by Amanda Peppard on 11/10/22.
//

import XCTest
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
@testable import Campus_Closet

class MessagesVMTests : XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor func testInitialization() {
        let messagesVM = MessagesVM()
        XCTAssertNotNil(messagesVM, "The messages view model should not be nil.")
        
    }
    

    
}
