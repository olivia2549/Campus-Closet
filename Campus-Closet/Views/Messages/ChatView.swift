//
//  ChatView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/29/22.
//

import SwiftUI

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var imageUrl = URL(string: "https://cdn.pixabay.com/photo/2017/09/25/13/12/cocker-spaniel-2785074_1280.jpg")
    var name = "Lauren Scott"
    var body: some View {
        HStack(spacing: 0){
            Styles.BackButton(presentationMode: self.presentationMode)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//            NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
//                Image(systemName: "chevron.backward")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 20, height: 20)
//                    //.padding(20)
//                    .foregroundColor(.black)
//                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 15))
//            }
            
            
            AsyncImage(url: imageUrl){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                
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
