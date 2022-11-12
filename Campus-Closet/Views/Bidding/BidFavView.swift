//
//  BidFav.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/6/22.
//

import SwiftUI
//import SlidingTabView

struct BidFavView: View {
    @State var offset: CGFloat = 0
    @State private var tabIndex = 0
    let maxHeight = UIScreen.main.bounds.height / 2.5
    var body: some View {
        VStack (alignment: .center, spacing: 10){
            HeaderDetailBid()
//                .zIndex(1)
                .padding(.leading)
                .padding(.trailing)
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct HeaderDetailBid: View{
    var body: some View{
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
    }
}
