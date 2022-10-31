//
//  EditItem.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/31/22.
//

import SwiftUI

struct EditItem: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject private var viewModel: ItemVM

    var body: some View {
        NavigationView {
            BasicInfo<ItemVM>(presentationMode: presentationMode)
                .environmentObject(viewModel)
                .navigationBarHidden(true)
        }
    }
}

struct EditItem_Previews: PreviewProvider {
    static var previews: some View {
        EditItem()
    }
}
