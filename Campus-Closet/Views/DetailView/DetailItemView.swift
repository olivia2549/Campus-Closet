//
//  ItemCardView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI

struct DetailItemView: View, Identifiable {
    let id = UUID()
    let imageStr: String
    init(for imageStr: String) {
        self.imageStr = imageStr
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(imageStr)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(10)
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
            VStack{
                HStack(alignment: .top, spacing: 0) {
                    Text("Knitted Sweater")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .frame(maxWidth: 250, alignment: .leading)
                        

                    Spacer()
                    
                    
                    Text("$8")
                        .font(.system(size: 30))
                        .foregroundColor(Styles().themePink)
                        .frame(maxWidth: 100, alignment: .trailing)
                    Spacer()
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
    
}
                                 
struct DetailItemView_Previews: PreviewProvider {
    static var previews: some View {
        DetailItemView(for: "sweater_preview")
    }
}
