//
//  ErrorView.swift
//  Campus-Closet
//
//  Created by Lauren Scott on 10/10/22.
//

import SwiftUI

@MainActor protocol ErrorVM: ObservableObject {
    var isError: Bool {get set}
    var message: String {get set}
}

struct ErrorView<ViewModel:ErrorVM>: View {
    @EnvironmentObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            if viewModel.isError {
                Color.black.opacity(0.35).edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .center, spacing: 0) {
                    Text(viewModel.message)
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        .font(Font.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .background(Styles().themePink)
                    
                    Button(action: {
                        withAnimation(.linear(duration: 0.2)){
                            viewModel.isError = false
                        }
                    }, label: {
                        Text("OK")
                            .frame(maxWidth: .infinity)
                            .frame(height: 60, alignment: .center)
                            .font(Font.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.15))
                    })
                }
                .frame(maxWidth: 320)
                .background(Styles().themePink)
                .border(.white, width: 3)
            }
        }
    }
}
