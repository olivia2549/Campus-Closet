//
//  HomeView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var contentVM = ContentVM()
    @EnvironmentObject var session: OnboardingVM
    @State private var addPostPresented = false
    @State private var selection = 0

    let maxWidth = UIScreen.main.bounds.width
    let maxHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: maxWidth*0.2, height: maxHeight*0.07, alignment: .leading)
                Spacer()
                if !session.isGuest {
                    Image(systemName: "plus.app")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: maxWidth*0.06)
                        .padding()
                        .environment(\.symbolVariants, .none)
                        .fullScreenCover(
                            isPresented: $addPostPresented,
                            onDismiss: {
                                selection = 0
                            },
                            content: { PostView() }
                        )
                        .onTapGesture {
                            addPostPresented.toggle()
                        }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            
            // Filter items
            VStack(alignment: .leading, spacing: 0) {
                    CustomSearch()
                    HStack {
                        Text("Filter By")
                            .font(.system(size: 20, weight: .semibold))
                        TagPicker<ContentVM>(menuText: "All")
                        Spacer()
                    }
                    
                    TagsList<ContentVM>()
                
            }
            .padding()
            
            // View items for sale in 2 Masonry-style columns
            ScrollView {
                Masonry<ContentVM>()
            }
            .scrollIndicators(.hidden)
        }
        .environmentObject(contentVM)
        .environmentObject(session)
        .onAppear {
            contentVM.fetchData()
        }
    }
}
