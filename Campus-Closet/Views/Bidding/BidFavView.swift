//
//  BidFav.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/6/22.
//

import SwiftUI
//import SlidingTabView

struct BidFavView: View {
//    @StateObject private var viewModel = ProfileVM()
    @State var offset: CGFloat = 0
    @State private var tabIndex = 0
    let maxHeight = UIScreen.main.bounds.height / 2.5
    var body: some View {
        VStack (alignment: .center, spacing: 10){
            HeaderDetailBid()
//                .zIndex(1)
                .padding(.leading)
                .padding(.trailing)
            
//
//            SlidingTabView(
//                selection: $tabIndex,
//                tabs: ["Favorites", "Bids"],
//                font: .system(size: 20, weight: .medium),
//                animation: .easeInOut,
//                activeAccentColor: Styles().themePink,
//                inactiveAccentColor: .gray,
//                selectionBarHeight: 0
//            )
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct BidFav_Previews: PreviewProvider {
    static var previews: some View {
        BidFavView()
    }
}


struct ToggleView2: View {
//    @EnvironmentObject private var viewModel: ProfileVM
    @State private var tabIndex = 0
    @State var offset: CGFloat = 0
    var maxHeight: CGFloat
    
    var body: some View {
        VStack {
//            SlidingTabView(
//                selection: $tabIndex,
//                tabs: ["Listed", "Sold", "Purchased"],
//                font: .system(size: 20, weight: .medium),
//                animation: .easeInOut,
//                activeAccentColor: Styles().themePink,
//                inactiveAccentColor: .gray,
//                selectionBarHeight: 0
//            )
//            .background(.white)
//            .offset(y: getPosition())
//            .modifier(OffsetModifier(offset: $offset))
//            .zIndex(1)
            if (tabIndex == 0) {
                
                //Text("hello")
//                Masonry<ProfileVM>()
//                    .zIndex(0)
            } else {
                Text("None yet")
            }
        }
//        .environmentObject(viewModel)
    }
    
    func getPosition() -> CGFloat {
        return offset < maxHeight ? (80 - offset) : (maxHeight - offset)
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
