//
//  MainMessagesView.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 11/10/22.
//

import SwiftUI
import Firebase

class MainMessagesViewModel: ObservableObject{
    init(){
        fetchCurrentUser()
    }
    private func fetchCurrentUser(){
        
    }
}



struct MainMessagesView: View {
    @State var shouldShowLogOutOptions = false
    @StateObject private var viewModel = ProfileVM()
    //@Binding var offset = CGFloat

    private var customNavBar: some View{
       
            HStack(spacing: 16){
                Image (systemName: "person.fill")
                    .font(.system(size:34, weight: .heavy))
                VStack(alignment: .leading, spacing: 4){
                    
                    Text("Hilly Yehoshua")
                        .font (.system(size: 24, weight: .bold) )
                        //.opacity(getNameOpacity())
                    HStack{
                        Circle()
                            .foregroundColor(.green)
                            .frame (width: 14, height: 14)
                        Text("online")
                            .font (.system(size: 12))
                            .foregroundColor(Color(.lightGray))
                    }
                }
                
                Spacer()
                Button{
                    shouldShowLogOutOptions.toggle()
                }label:{
                    Image(systemName: "gear")
                        .font(.system(size: 24, weight: .bold))
                }
                
            }
            .padding()
            .actionSheet(isPresented: $shouldShowLogOutOptions){
                .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [.default(Text("DEFAULT BUTTON")),
                    .cancel()
                                                                                                  ])
        }
        
       
    }
    var body: some View {
        NavigationStack{
            
            VStack{
                //custom nav bar
                customNavBar
                
                
                
                messagesView
               

                
                
            }
            .overlay(
                newMessageButton, alignment: .bottom
                
            )
            .navigationBarHidden(true)
            
        }
    }
    private var messagesView: some View{
        ScrollView{
            ForEach(0..<10, id: \.self){ num in
                VStack{
                    HStack (spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44)
                                .stroke(Color.black, lineWidth: 1))
                        
                        
                        VStack (alignment: .leading){
                            Text("Username")
                                .font(.system(size:16, weight: .bold))
                            Text("Message sent to user")
                                .font(.system(size:14))
                                .foregroundColor(Color(.lightGray))
                        }
                        Spacer()

                        Text("22d")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                
                Divider()
                    .padding(.vertical, 8)
                
            }.padding(.horizontal)
        }.padding(.bottom, 50)
    }
    
    
    @State var shouldShowNewMessageScreen = false
    
    private var newMessageButton: some View{
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack{
                Spacer()
                Text("+ New Message")
                    .font (.system(size: 16, weight: .bold))
                    
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color("Dark Pink"))
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen){
            CreateNewMessageView()
        }
    }
}





struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
            .preferredColorScheme(.dark)
        MainMessagesView()
    }
}
