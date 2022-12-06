//
//  ContentView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/22/22.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @EnvironmentObject var session: OnboardingVM
    @State private var selection: Int = 0
    @State private var addPostPresented = false
    
    init() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black
        UITabBar.appearance().itemPositioning = .centered
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                // Icon to navigate to home marketplace screen.
                HomeView(tabSelection: $selection)
                    .tabItem {
                        if (selection == 0) {
                            Image(systemName: "house.fill")
                        }
                        else {
                            Image(systemName: "house")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tag(0)
                
                // Icon to navigate to main messaging screen.
                MainMessagesView()
                    .tabItem {
                        if (selection == 1) {
                            Image(systemName: "message.fill")
                        }
                        else {
                            Image(systemName: "message")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tag(1)
                
                // Icon to navigate to profile view screen.
                ProfileView(tabSelection: $selection)
                    .tabItem {
                        if (selection == 2) {
                            Image(systemName: "person.fill")
                        }
                        else {
                            Image(systemName: "person")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tag(2)
            }
            .accentColor(.black)
            .navigationBarHidden(true)
        }
        .environmentObject(session)
    }
}
