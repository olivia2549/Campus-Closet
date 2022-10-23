//
//  Shared.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/23/22.
//

import Foundation
import SwiftUI

struct Shared {
    let themePink = Color("Dark Pink")
    
    struct BackButton: View {
        var presentationMode: Binding<PresentationMode>
        init(presentationMode: Binding<PresentationMode>) {
            self.presentationMode = presentationMode
        }
        
        var body: some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                ZStack {
                    Circle()
                        .strokeBorder()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    struct CancelButton: View {
        var presentationMode: Binding<PresentationMode>
        init(presentationMode: Binding<PresentationMode>) {
            self.presentationMode = presentationMode
        }
        
        var body: some View {
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                ZStack(alignment: .center) {
                    Circle()
                        .strokeBorder()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                    Text("x")
                        .font(.system(size: 20, weight: .light))
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    struct PinkButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .background(Shared().themePink)
                .cornerRadius(10)
                .padding(.top)
                .foregroundColor(.white)
        }
    }
    
}

// allow user to swipe back
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
