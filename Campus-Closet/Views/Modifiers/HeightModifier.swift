//
//  HeightModifier.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/12/22.
//

import SwiftUI

struct HeightModifier: ViewModifier {
    @Binding var height: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{ proxy -> Color in
                    DispatchQueue.main.async {
                        self.height = proxy.size.height
                    }
                    return Color.clear
                }, alignment: .top
            )
    }
}
