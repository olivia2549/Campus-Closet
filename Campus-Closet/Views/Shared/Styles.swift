//
//  Styles.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/23/22.
//

import Foundation
import SwiftUI

struct Styles {
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
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .padding(20)
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
                    Image(systemName: "xmark")
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    struct PinkButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .background(Styles().themePink)
                .cornerRadius(10)
                .padding(.top)
                .foregroundColor(.white)
        }
    }
    
    struct PinkTextButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .background(.white)
                .cornerRadius(10)
                .padding(.top)
                .font(Font.system(size: 16, weight: .semibold))
                .foregroundColor(Styles().themePink)
        }
    }
    
    struct SearchBar: View {
        @State var searchText = ""
        var body: some View {
            ZStack {
                Color("Search Bar")
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                            TextField("Search ..", text: $searchText)
                        }
                        .padding(.leading, 13)
                    )
            }
            .frame(height: 40)
            .cornerRadius(10)
            .padding()
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

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
