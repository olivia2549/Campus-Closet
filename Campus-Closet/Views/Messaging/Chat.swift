//
//  Chat.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct Chat: View {
    var imageUrl = URL(string: "https://cdn.pixabay.com/photo/2017/09/25/13/12/cocker-spaniel-2785074_1280.jpg")
    var name = "Sarah Smith"
    var body: some View {
        HStack(spacing: 20){
            AsyncImage(url: imageUrl){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            
            VStack (alignment: .leading){
                Text(name)
                    .font(.title).bold()
                    .foregroundColor(.white)
                Text ("online")
                    .font(.caption)
                    .foregroundColor(.white)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding (10)
                .background(.white)
                .cornerRadius(50)
        }
        .padding()
    }
    
}


struct Chat_Previews: PreviewProvider {
    static var previews: some View {
        Chat()
            .background(Color("Dark Pink"))
    }
}
