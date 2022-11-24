//
//  InitialView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/23/22.
//

import Foundation
import SwiftUI

struct InitialView: View {
    @EnvironmentObject var session: OnboardingVM
    func listen() {
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
