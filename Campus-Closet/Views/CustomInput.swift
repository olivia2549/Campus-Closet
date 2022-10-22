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
    let autocapitalization: TextInputAutocapitalization
    var completion: () -> Void
    
    init(
        for inputLabel: String,
        autocapitalization: TextInputAutocapitalization,
        input: Binding<String>,
        completion: @escaping () -> Void
    ){
        self.inputLabel = inputLabel
        self.autocapitalization = autocapitalization
        self._input = input
        self.completion = completion
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                Text(inputLabel)
                    .font(.system(size: 20, weight: .semibold))
                TextField("", text: $input)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray)
                            .frame(height: 50)
                    )
                    .textInputAutocapitalization(autocapitalization)
                    .onSubmit {
                        completion()
                    }
            }
            .padding()
        }
    }
    
}

//struct CustomInput_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomInput(for: "Name", autocapitalization: .words)
//    }
//}
