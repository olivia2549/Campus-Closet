//
//  BidItem.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/6/22.
//

import SwiftUI

struct BidItem: View {
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center){
//            HeaderDetail()
//                .zIndex(1)
//                .padding(.leading)
//                .padding(.trailing)

            Text("Make an offer")
                .fontWeight(.semibold)
                .font(.system(size: 45))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            Text("Current Listing Price: $8")
                .fontWeight(.semibold)
                .font(.system(size: 20))
                .foregroundColor(Color("Dark Gray"))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0))
            Image("flower")
                .resizable()
                .scaledToFit()
                .frame(width: 300)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            Text("Your offer")
                .fontWeight(.semibold)
                .foregroundColor(Color("Dark Pink"))
                .font(.system(size: 25))
            VStack(alignment: .center) {
                HStack(alignment: .center){
                
                    Text("$")
                        .font(.system(size:80))
                        .padding (.leading)
                    TextField("0", text: $name)
                        .font(.system(size:100))
                        .padding (.leading)
                }
            }
            HStack {
                Spacer()
                NavigationLink(destination: BidFavView()){
                    Text("Send Bid Offer")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth:15)
                        )
                }
                .background(Color("Dark Pink"))
                .cornerRadius(25)
                Spacer()
            }
            


            
            Spacer()
        }
        .navigationBarHidden(true)
        
    }
        
}

struct BidItem_Previews: PreviewProvider {
    static var previews: some View {
        BidItem()
    }
}
