//
//  PostView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct PostView: View {
    @StateObject private var postVM = PostVM()
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color("Dark Pink"))
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            VStack {
                ItemInfoFormBox()
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
        .environmentObject(postVM)
    }
}

struct ItemInfoFormBox: View {
    @EnvironmentObject private var viewModel: PostVM
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            // FIXME: Button needs frontend formatting. This is just prototype to test Firebase connection.
            Button(action: {viewModel.postItem()}){
                HStack{
                    Text("Post Item!")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(10)
            .background(Color("Dark Pink"))
            .foregroundColor(Color.white)
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
