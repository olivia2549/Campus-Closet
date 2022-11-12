//
//  Masonry.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI
import UIKit

@MainActor protocol RenderContentVM: ObservableObject {
//    var sortedColumns: [[String]] { get set }
    var content: [String] { get set }
}

struct Masonry<ViewModel>: View where ViewModel: RenderContentVM {
    @EnvironmentObject private var viewModel: ViewModel
    let vertSpacing: CGFloat = 25
    let horizSpacing: CGFloat = 10
    private var gridColLayout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        HStack(alignment: .top, spacing: horizSpacing) {
            if (viewModel.content.count == 0) {
                Text("Nothing to show")
            }
            LazyVGrid(columns: gridColLayout) {
                ForEach(viewModel.content.reversed(), id: \.self) { id in
                    ItemCardView(for: id)
                }
            }
        }
        .padding(horizSpacing)
    }
}
