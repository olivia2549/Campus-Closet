//
//  ErrorView.swift
//  Campus-Closet
//
//  Created by Lauren on 10/10/22.
//

import SwiftUI

struct ErrorView: View {
    @EnvironmentObject private var viewModel: OnboardingVM
    
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
                        .background(Color("Dark Pink"))
                    
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
                .background(Color("Dark Pink"))
                .border(.white, width: 3)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    @State static private var showMessage: Bool = false
    
    static var previews: some View {
        ErrorView()
    }
}
