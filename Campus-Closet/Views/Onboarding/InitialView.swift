//
//  InitialView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/23/22.
//

import Foundation
import SwiftUI

// Structure that directs navigation between initial screens according to user permissions.
struct InitialView: View {
    @EnvironmentObject var session: OnboardingVM
    
    func listen() {
        // Keep track of any changes in user permissions.
        session.listenAuthenticationState()
    }
    
    var body: some View {
        Group {
            if !session.isLoggedIn {
                LogInView()
            } else if session.isGuest {
                ContentGuestView()
            } else {
                ContentView()
            }
        }
        .onAppear(perform: listen)
        .environmentObject(session)
    }
}
