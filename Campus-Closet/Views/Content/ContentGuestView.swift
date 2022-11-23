//
//  ContentGuestView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 11/22/22.
//

import SwiftUI
import UIKit

struct ContentGuestView: View {
    @State var isGuest = true
    
    init() {
        UIToolbar.appearance().barTintColor = UIColor(Styles().themePink)
    }
    
    var body: some View {
        NavigationView {
            HomeView(isGuest: $isGuest)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            if let window = UIApplication.shared.windows.first {
                                window.rootViewController = UIHostingController(rootView: LogInView())
                                window.makeKeyAndVisible()
                            }
                        }){
                            Text("Log In to Access All Features")
                                .font(Font.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
        }
    }
}

