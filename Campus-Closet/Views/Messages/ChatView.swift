//
//  ChatView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//
import SwiftUI

struct ChatView: View {
    var imageUrl = URL(string: "https://cdn.pixabay.com/photo/2017/09/25/13/12/cocker-spaniel-2785074_1280.jpg")
    var name = "Lauren Scott"
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
        .navigationBarHidden(true)
        .padding()
    }

}


struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .background(Color("Dark Pink"))
    }
}
