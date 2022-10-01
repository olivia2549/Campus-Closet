//
//  ContentView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/22/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    init() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black
        UITabBar.appearance().itemSpacing = 5
        UITabBar.appearance().itemPositioning = .centered
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
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
            PostView()
                .tabItem {
                    if (selection == 1) {
                        Image(systemName: "plus.app.fill")
                    }
                    else {
                        Image(systemName: "plus.app")
                            .environment(\.symbolVariants, .none)
                    }
                }
                .tag(1)
            ChatView()
                .tabItem {
                    if (selection == 2) {
                        Image(systemName: "message.fill")
                    }
                    else {
                        Image(systemName: "message")
                            .environment(\.symbolVariants, .none)
                    }
                }
                .tag(2)
            ProfileView()
                .tabItem {
                    if (selection == 3) {
                        Image(systemName: "person.fill")
                    }
                    else {
                        Image(systemName: "person")
                            .environment(\.symbolVariants, .none)
                    }
                }
                .tag(3)
        }
        .accentColor(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
