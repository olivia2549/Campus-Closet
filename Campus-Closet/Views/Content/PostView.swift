//
//  PostView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct PostView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("Dark Pink"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            VStack {
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Post An Item")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.top, 50)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EnterStats()) {
                        Text("Next")
                    }
                }
            }
        }
    }
}

struct EnterStats: View {
    @State var description: String = ""
    var body: some View {
        TextField("Description", text: $description)
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
