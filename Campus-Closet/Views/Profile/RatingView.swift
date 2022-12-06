//
//  RatingView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 11/23/22.
//

import SwiftUI

struct RatingView: View {
    @EnvironmentObject private var viewModel: ProfileVM
    @Binding var sellerID: String
    @Binding var showRatingView: Bool
    
    var body: some View {
        VStack(alignment: .center){
            Text("Rate your transaction")
                .fontWeight(.semibold)
                .font(.system(size: 30))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            HStack {
                Button(action: {
                    viewModel.newRating = 1
                }){
                    viewModel.newRating >= 1 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    viewModel.newRating = 2
                }){
                    viewModel.newRating >= 2 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    viewModel.newRating = 3
                }){
                    viewModel.newRating >= 3 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    viewModel.newRating = 4
                }){
                    viewModel.newRating >= 4 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    viewModel.newRating = 5
                }){
                    viewModel.newRating == 5 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
            }
            
            Spacer().frame(height: 35)
            
            Button(action: {
                viewModel.submitRating(sellerID: sellerID)
                showRatingView = false
            }) {
                Text("Submit Rating")
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
