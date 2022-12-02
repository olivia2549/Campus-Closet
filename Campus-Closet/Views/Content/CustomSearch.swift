//
//  CustomSearch.swift
//  Campus-Closet
//
//  Created by Hilly Yehoshua on 12/2/22.
//

import SwiftUI
import Firebase

struct CustomSearch: View {
    @ObservedObject var data = getData()
    
    var body: some View {
        NavigationView{
            ZStack (alignment: .top){
                GeometryReader{
                    _ in
                    Text ("Home")
                }.background(Color ("Dark Pink").edgesIgnoringSafeArea(.all))
                CustomSearchBar(data: self.$data.datas).padding(.top)
            }
        }
    }
}

struct CustomSearch_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearch()
    }
}


struct CustomSearchBar: View {
    @State var txt = ""
    @Binding var data : [dataType]
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
                TextField("Search", text: self.$txt)
                
                
                if self.txt != "" {
                    Button (action: {
                        self.txt = ""
                    }){
                        Text("Cancel")
                    }
                    .foregroundColor(.black)
                }
            }.padding()
            if self.txt != ""{
                if self.data.filter({$0.name.lowercased().contains(self.txt.lowercased())}).count == 0{
                    
                    Text ("No results found.").foregroundColor(Color.black.opacity(0.5)).padding()
                }
                else{
                    List(self.data.filter{$0.name.lowercased().contains(self.txt.lowercased())}) { i in
                        SearchResult(id: i.id, name: i.name)
                    }
                }
            }
        }.background(Color.white)
            .padding()
    }
    
}

struct SearchResult: View {
    @StateObject var viewModel = ItemVM()
    var id: String
    var name: String
    
    var body: some View {
        NavigationLink (destination: DetailView<ItemVM>(itemInfoVM: viewModel)) {
            Text(name)
        }
        .onAppear() {
            viewModel.fetchSeller(with: id) {}
        }
    }
}

class getData : ObservableObject{
    
    @Published var datas = [dataType]()
    
    init(){
        let db = Firestore.firestore()
        db.collection("items").getDocuments{ (snap, err) in
            
            if err != nil {
                print ((err?.localizedDescription)!)
                return
            }
            for i in snap!.documents{
                let id = i.get("_id") as! String
                let name = i.get("title") as! String
                self.datas.append(dataType(id: id, name: name))
                
            }
            
        }
    }
}

struct dataType : Identifiable {
    var id : String
    var name : String
}

