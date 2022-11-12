//
//  ContentView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/22/22.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var selection = 0
    @State private var addPostPresented = false
    
    init() {
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().unselectedItemTintColor = .black
        UITabBar.appearance().itemSpacing = 5
        UITabBar.appearance().itemPositioning = .centered
    }
    
    var body: some View {
        NavigationView {
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
                Chat_Message()
                    .tabItem {
                        if (selection == 3) {
                            Image(systemName: "message.fill")
                        }
                        else {
                            Image(systemName: "message")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tag(3)
                Text("")
                    .fullScreenCover(
                        isPresented: $addPostPresented,
                        onDismiss: {
                            selection = 0
                        },
                        content: { PostView() }
                    )
                    .onAppear {
                        addPostPresented.toggle()
                    }
                    .tabItem {
                        if (selection == 2) {
                            Image(systemName: "plus.app.fill")
                        }
                        else {
                            Image(systemName: "plus.app")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tag(2)

//                BidFavView()
//                    .tabItem {
//                        if (selection == 1) {
//                            let imageConfig = UIImage(systemName: "cart.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .black))!
//                            Image(uiImage: imageConfig)
//                        }
//                        else {
//                            Image(systemName: "cart")
//                            .environment(\.symbolVariants, .none)
//                        }
//                    }
//                    .tag(1)
                ProfileView()
                    .tabItem {
                        if (selection == 4) {
                            Image(systemName: "person.fill")
                        }
                        else {
                            Image(systemName: "person")
                                .environment(\.symbolVariants, .none)
                        }
                    }
                    .tag(4)
            }
            .accentColor(.black)
            .navigationBarHidden(true)
        }
    }
}
