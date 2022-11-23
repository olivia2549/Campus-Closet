//
//  RatingView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 11/23/22.
//

import SwiftUI

struct RatingView: View {
    @State private var newRating = 0
    
    var body: some View {
            HStack {
                Button(action: {
                    newRating = 1
                }){
                    newRating >= 1 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    newRating = 2
                }){
                    newRating >= 2 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    newRating = 3
                }){
                    newRating >= 3 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    newRating = 4
                }){
                    newRating >= 4 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
                
                Button(action: {
                    newRating = 5
                }){
                    newRating == 5 ?
                    Image(systemName: "star.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                    :
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(Color("Dark Pink"))
                }.offset(x: -maxWidth*0.03, y: maxWidth*0.02)
            }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
