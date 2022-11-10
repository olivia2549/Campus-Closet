//
//  GeneralMessages.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/8/22.
//

import SwiftUI

struct GeneralMessages: View {
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView {
            VStack (alignment: .center, spacing: 0){
                    MessagingHeader()
                    NavigationView {
                        Text("\(searchText)") .searchable(text: $searchText, prompt: "Search for a user ")
                        
                        
                    }
                    
                        VStack (alignment: .leading, spacing: 0){
                            MessageSingle()
                            Divider()
                                .padding (EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                            MessageSingle()
                            MessageSingle()
                            Spacer()
                        }
                    
                    

            }
        }
        
    }
}



struct MessageSingle: View {
    //    @ObservedObject private var zipCodeModel = ZipCodeModel()
    var body: some View {
        VStack
        {
            HStack{
                Image ("blank-profile")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                VStack (alignment:.leading, spacing: 0){
                    Text ("John Smith")
                        .fontWeight(.semibold)
                        .font(.system(size: 15))
                    Text ("This is the last message that John received. I need to find a way to wrap this")
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                        .font(.system(size: 14))
                }
                
                
            }
            //Spacer()
        }
    }
}

struct MessagingHeader: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        HStack{
            Styles.BackButton(presentationMode: self.presentationMode)
            Spacer()
            Text("Messages")
                .font(.system(size: 30))
                .padding(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
            Spacer()
            NavigationLink(destination: Chat_Message()){
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }
            
        }
    }
}

struct GeneralMessages_Previews: PreviewProvider {
    static var previews: some View {
        GeneralMessages()
    }
}

