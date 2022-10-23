//
//  CustomInput.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/22/22.
//

import SwiftUI

struct CustomInput: View {
    @Binding var input: String
    let inputLabel: String
    let imageName: String
    let autocapitalization: TextInputAutocapitalization
    var completion: () -> Void
    
    init(
        for inputLabel: String,
        imageName: String,
        autocapitalization: TextInputAutocapitalization,
        input: Binding<String>,
        completion: @escaping () -> Void
    ){
        self.inputLabel = inputLabel
        self.imageName = imageName
        self.autocapitalization = autocapitalization
        self._input = input
        self.completion = completion
    }

    let textFieldHeight: CGFloat = 60
    @State private var isEditing = false
    var shouldPlaceHolderMove: Bool {
        isEditing || (input.count != 0)
    }
    var textFieldOutline: Color {
        isEditing ? Color("Dark Pink") : .gray
    }
    var textFieldHighlight: Color {
        isEditing ? Color("Dark Pink").opacity(0.1) : .white
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(textFieldOutline)
                .background(textFieldHighlight)
                .frame(height: textFieldHeight)
                .cornerRadius(10)
            HStack {
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .padding(.leading)
                Divider()
                    .frame(height: 30)
                ZStack(alignment: .leading) {
                    TextField("", text: $input, onEditingChanged: { (edit) in
                        isEditing = edit
                    })
                    .foregroundColor(Color.primary)
                    .padding(shouldPlaceHolderMove ?
                             EdgeInsets(top: textFieldHeight*0.3, leading: 5, bottom: 0, trailing: 0) :
                             EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .accentColor(Color.secondary)
                    .animation(.linear)
                    ///Floating Placeholder
                    Text(inputLabel)
                        .foregroundColor(textFieldOutline)
                        .padding(shouldPlaceHolderMove ?
                                 EdgeInsets(top: 0, leading: 5, bottom: textFieldHeight*0.5, trailing: 0) :
                                 EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                        .scaleEffect(shouldPlaceHolderMove ? 1.0 : 1.2)
                        .animation(.linear)
                }
            }
        }
        .padding(.bottom, 20)
    }
    
}
