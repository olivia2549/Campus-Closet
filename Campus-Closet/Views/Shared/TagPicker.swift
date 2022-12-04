//
//  TagPicker.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/23/22.
//

import SwiftUI

struct TagPicker<ViewModel>: View where ViewModel: HandlesTagsVM {
    @EnvironmentObject private var viewModel: ViewModel
    @State private var shouldShowDropdown = false
    var menuText: String
    
    init(menuText: String) {
        self.menuText = menuText
    }

    var body: some View {
        Menu {
            ForEach(viewModel.tagsLeft.sorted(by: >), id: \.key) { key, value in
                if (value == 1) {
                    Button(
                        action: {
                            viewModel.addTag(for: key)
                            self.shouldShowDropdown.toggle()
                        },
                        label: { Text(key) }
                    )
                }
            }
        } label: {
            HStack {
                Text(menuText).foregroundColor(.gray)
                Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up" : "arrowtriangle.down")
                    .resizable()
                    .frame(width: 9, height: 5)
                    .font(Font.system(size: 9, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .onTapGesture {
            self.shouldShowDropdown.toggle()
        }
        
    }
}
