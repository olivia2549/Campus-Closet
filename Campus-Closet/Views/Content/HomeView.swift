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
    @State var show = false
    @State var sortLabel = "New Arrivals"
    @Binding var tabSelection: Int
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
                            content: { PostView(tabSelection: $tabSelection) }
                        )
                        .onTapGesture {
                            addPostPresented.toggle()
                        }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            
            // Filter and sort items.
            VStack(alignment: .leading, spacing: maxHeight*0.02) {
                CustomSearch().frame(height: maxHeight*0.05)
                HStack {
                    // Select filter options.
                    Text("Filter By")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .semibold))
                    TagPicker<ContentVM>(menuText: "All")
                        .frame(width: maxWidth*0.2)
                    Spacer()
                    
                    // Select sorting options.
                    Text("\(sortLabel)")
                        .foregroundColor(.black)
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: maxWidth*0.4, alignment: .trailing)
                    Menu {
                        // Sort items from lowest to highest price.
                        Button {
                            contentVM.sortField = "price"
                            contentVM.sortDescending = true
                            contentVM.fetchData()
                            sortLabel = "Price: Low to High"
                        } label: {
                            Text("Price: Low to High")
                        }
                        
                        // Sort items from highest to lowest price.
                        Button {
                            contentVM.sortField = "price"
                            contentVM.sortDescending = false
                            contentVM.fetchData()
                            sortLabel = "Price: High to Low"
                        } label: {
                            Text("Price: High to Low")
                        }
                        
                        // Sort items from most to least recent.
                        Button {
                            contentVM.sortField = "timestamp"
                            contentVM.sortDescending = false
                            contentVM.fetchData()
                            sortLabel = "New Arrivals"
                        } label: {
                            Text("New Arrivals")
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.black)
                    }
                }
                TagsList<ContentVM>()
            }
            .padding()
            
            // View items for sale in 2 Masonry-style columns.
            ScrollView {
                Masonry<ContentVM>(tabSelection: $tabSelection)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.immediately)
        }
        .environmentObject(contentVM)
        .environmentObject(session)
        .onAppear { contentVM.fetchData() }
        .onTapGesture { hideKeyboard() }
    }
}
