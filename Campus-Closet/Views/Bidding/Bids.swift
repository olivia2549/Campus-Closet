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
    @EnvironmentObject var session: OnboardingVM
    @State var itemId: String
    @Binding var tabSelection: Int
    let isAnonymous: Bool
    var presentationMode: Binding<PresentationMode>
    
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
                        AcceptOffers(tabSelection: $tabSelection, bid: bid, presentationMode: presentationMode)
                    }
                }
            }
        }
        .environmentObject(session)
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
    @EnvironmentObject var session: OnboardingVM
    @Binding var tabSelection: Int
    var bid: Bid
    var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            HStack(alignment: .center) {
                NavigationLink(destination: SellerProfileView(tabSelection: $tabSelection).environmentObject(profileVM)) {
                    if (profileVM.profilePicture != nil) {
                        Image (uiImage: profileVM.profilePicture!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                    }
                    else {
                        Image("blank-profile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(profileVM.user.name)
                            .foregroundColor(.black)
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
                                .foregroundColor(.black)
                                .font(.system(size: 12))
                        }
                    }
                }
                Spacer()
                
                if (itemVM.isSeller) {
                    Button(action: {
                        itemVM.sellItem(bid: bid)
                        profileVM.sellItem(with: bid.itemId)
                        presentationMode.wrappedValue.dismiss()
                        tabSelection = 1
                    }) {
                        Text("Accept $\(bid.offer)")
                            .frame(maxWidth: maxWidth*0.3, alignment: .center)
                    }
                    .buttonStyle(Styles.PinkButton())
                }
                else {
                    NavigationLink(destination: Chat_Message(partnerId: bid.bidderId).environmentObject(session).environmentObject(MessagesVM())) {
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
