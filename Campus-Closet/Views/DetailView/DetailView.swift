//
//  DetailView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 10/25/22.
//

import SwiftUI

struct DetailView: View {
    
    //@ObservedObject private var itemVM = ItemVM()
    //itemGrab = db.collection("items").doc("57E2051C-CE4B-43A4-AE80-68C17CD55628")
    

    //57E2051C-CE4B-43A4-AE80-68C17CD55628
    var body: some View {
        VStack (spacing: 0){
            HeaderDetail()
            ScrollView {
                VStack (alignment: .leading, spacing: 0){
                    
                    DetailItemView(for: "sweater")
                    Spacer()
                    //ButtonRow()
                    DetailDescription()
                    Spacer()
                    
                    Divider()
                        .frame(height: 1)
                        .overlay(Color("Dark Gray"))
                    
                    SellerInfo()
                    
                    
                    
                    Button(action: {
                        print("Place Bid")
                    }){
                        Text("Place Bid")
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
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}



struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
        
        
    }
}


struct HeaderDetail: View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View{
        VStack(spacing: 0) {
            HStack {
                Styles.BackButton(presentationMode: self.presentationMode)
                Spacer()
                Spacer().frame(maxWidth: 10)
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 50, alignment: .leading)
                Spacer()
                Image(systemName: "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .padding(7)
                Image(systemName: "bell")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}


struct ButtonRow: View{
    var body: some View{
        VStack (alignment: .leading){
            HStack { //fit to text
                Button(action: {
                    print("Tag")
                }){
                    Text("Sweater")
                        .frame(minWidth: 0, maxWidth: 100)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 24)
                        )
                }
                .background(Color("Dark Gray"))
                .cornerRadius(25)
                
                Button(action: {
                    print("Condition")
                }){
                    Text("New")
                        .frame(minWidth: 0, maxWidth: 50)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay (
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth:24)
                        )
                }
                .background(Color("Dark Gray"))
                .cornerRadius(25)
            }
        }
    }
}


struct ItemImage: View{
    var body: some View{
        HStack {
            Image("sweater")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(alignment: .topTrailing){
                    Button(action: {
                        print("Add to favorites")
                    }){
                        Image(systemName: "heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                            .foregroundStyle(Color("Dark Pink"))
                        
                    }.offset(x: -18, y: 20)
                    
                }
        }
    }
}

struct DetailDescription: View{
    var body: some View{
        HStack{
            Spacer()
            Spacer()
            Text("Details")
                .underline()
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        HStack{
            Spacer()
            Spacer()
            Text("This is the description This is the of item in the photo above. This is the description of item in the photo above.")
            
            Spacer()
            Spacer()
        }
    }
}

struct SellerInfo: View{
    var body: some View{
        VStack (alignment: .leading, spacing: 0) {
            HStack{
                Image ("blank-profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 0))
                VStack(spacing: 0) {
                    Text("Seller Name")
                        .font(.system(size: 18))
                    Text("@Seller-Name")
                        .foregroundColor(Color("Dark Gray"))
                        .font(.system(size: 14))
                    HStack (spacing: 2){
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color("Dark Pink"))
                        Text ("4.8 (12 Reviews)")
                            .font(.system(size: 12))
                    }
                }
                Spacer()
                NavigationLink(destination: Chat_Message()) {
                    Image (systemName: "ellipsis.message.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color("Dark Pink"))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
                }
                
                
                
                
            }
        }
    }}

