//
//  ContentGuestView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 11/22/22.
//

import SwiftUI
import UIKit

struct ContentGuestView: View {
    @EnvironmentObject var session: OnboardingVM
    @State var selection: Int = 0
    
    init() {
        UIToolbar.appearance().barTintColor = UIColor(Styles().themePink)
    }
    
    var body: some View {
        NavigationView {
            HomeView(tabSelection: $selection)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button(action: {
                            session.logOut()
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
