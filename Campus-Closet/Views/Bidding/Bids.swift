//
//  Bids.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/22/22.
//

import Foundation
import SwiftUI

struct Bids: View {
    @StateObject private var bidsVM = BidsVM()
    @EnvironmentObject private var itemVM: ItemVM
    @State var itemId: String
    let isAnonymous: Bool
    
    var body: some View {
        ScrollView {
            ForEach(bidsVM.bids.sorted(by: { $0.timestamp.compare($1.timestamp) == .orderedDescending }), id: \.id) { bid in
                VStack(alignment: .leading) {
                    if (isAnonymous) {
                        Divider()
                            .frame(width: maxWidth/2, alignment: .leading)
                        AnonymousOffers(bid: bid)
                    } else {
                        Divider()
                        AcceptOffers(bid: bid)
                    }
                }
            }
        }
        .onAppear {
            bidsVM.getBids(for: itemId)
        }
    }
}

struct AnonymousOffers: View {
    var bid: Bid
    var dateFormatter: DateFormatter
    
    init(bid: Bid) {
        self.bid = bid
        self.dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
    }
    
    var body: some View {
        HStack(spacing: maxWidth/6) {
            VStack(alignment: .leading) {
                Text("\(dateFormatter.string(from: bid.timestamp))")
                    .font(.system(size: 16))
                Text(bid.timestamp, style: .time)
                    .font(.system(size: 12))
            }
            Text("$\(bid.offer)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Styles().themePink)
            Spacer()
        }
    }
}

struct AcceptOffers: View {
    @StateObject private var profileVM = ProfileVM()
    @EnvironmentObject private var itemVM: ItemVM
    var bid: Bid
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                if (profileVM.profilePicture != nil) {
                    Image (uiImage: profileVM.profilePicture!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(50)
                }
                else {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color("LightGrey"))
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(profileVM.user.name)
                        .font(.system(size: 18))
                    Text("@\(profileVM.user.venmo)")
                        .foregroundColor(Color("Dark Gray"))
                        .font(.system(size: 14))
                    HStack (spacing: 2){
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("Dark Pink"))
                        Text ("\(String(format: "%.2f", profileVM.averageRating)) (\(profileVM.numRatings) \(profileVM.numRatings == 1 ? "Rating" : "Ratings"))")
                            .font(.system(size: 12))
                    }
                }
                Spacer()
                
                if (itemVM.isSeller) {
                    Button(action: {
                        itemVM.sellItem()
                        profileVM.sellItem(with: bid.itemId)
                    }) {
                        Text("Accept $\(bid.offer)")
                            .frame(maxWidth: maxWidth*0.3, alignment: .center)
                    }
                    .buttonStyle(Styles.PinkButton())
                }
                else {
                    NavigationLink(destination: Chat_Message(partnerId: bid.bidderId)) {
                        Image(systemName: "ellipsis.message.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("Dark Pink"))
                    }
                }
            }
        }
        .onAppear {
            let user = profileVM.fetchUser(userID: bid.bidderId)
        }
    }
}
