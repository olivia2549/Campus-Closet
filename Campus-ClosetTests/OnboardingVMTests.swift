//
//  OnboardingVMTests.swift
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

class OnboardingVMTests : XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    @MainActor func testInitialization() {
        let onboardingVM = OnboardingVM()
        XCTAssertNotNil(onboardingVM, "The onboarding view model should not be nil.")
        
    }
    

    
}

