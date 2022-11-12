//
//  EditItem.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/31/22.
//

import SwiftUI

struct EditItem: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var itemViewModel: ItemVM

    var body: some View {
        NavigationView {
            BasicInfo<ItemVM>(presentationMode: presentationMode)
                .environmentObject(itemViewModel)
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Styles.BackButton(presentationMode: self.presentationMode)
                            .foregroundColor(.black)
                    }
                }
        }
    }
}

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        EditItem()
    }
}
