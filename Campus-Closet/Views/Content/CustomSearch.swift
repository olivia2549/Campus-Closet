//
//  CustomSearch.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 12/2/22.
//

import SwiftUI
import Firebase

struct CustomSearch: View {
    @EnvironmentObject var contentVM: ContentVM
    
    var body: some View {
        NavigationView{
            VStack {
                CustomSearchBar()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("#d7d7d8"), lineWidth: 2)
                    )
            }
            .environmentObject(contentVM)
        }
    }
}

struct CustomSearchBar: View {
    @EnvironmentObject var contentVM: ContentVM
    
    var body: some View {
        let binding = Binding<String>(get: {
            contentVM.searchTxt
        }, set: {
            contentVM.searchTxt = $0
            contentVM.fetchData()
        })

        HStack{
            TextField("Search", text: binding)
                .padding(5)
                .submitLabel(.search)
                .disableAutocorrection(true)
                .onSubmit {
                    contentVM.fetchData()
                }
            if contentVM.searchTxt != "" {
                Button (action: {
                    contentVM.searchTxt = ""
                    contentVM.fetchData()
                }){
                    Text("Cancel")
                }
                .foregroundColor(.black)
                .padding(.trailing, 5)
            }
        }
        .padding(5)
    }
    
}
