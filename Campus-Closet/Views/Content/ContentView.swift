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
    @State private var selection = 0
    @State private var addPostPresented = false
    
    init() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black
        UITabBar.appearance().itemPositioning = .centered
    }
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                CustomSearch()
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
                ProfileView()
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
