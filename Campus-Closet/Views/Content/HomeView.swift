//
//  HomeView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var contentVM = ContentVM()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 50, alignment: .leading)
                    Spacer()
                    Image(systemName: "bookmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15)
                        .padding(7)
                    Image(systemName: "bell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                }
                .padding(.leading)
                .padding(.trailing)
                
                // Filter items
                VStack(alignment: .leading) {
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
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .environmentObject(contentVM)
            .onAppear {
                contentVM.fetchData()
            }
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
