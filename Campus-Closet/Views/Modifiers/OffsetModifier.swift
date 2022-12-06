//
//  OffsetModifier.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 10/31/22.
//

import SwiftUI

// Structure for a view that uses asynchronous processing to manage scrolling.
struct OffsetModifier: ViewModifier {
    @Binding var offset: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader{ proxy -> Color in
                    let minY = proxy.frame(in: .named("SCROLL")).minY
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    return Color.clear
                }, alignment: .top
            )
    }
}
