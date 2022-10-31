//
//  Masonry.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI
import UIKit

struct Column: Identifiable {
    let id = UUID()
    var items = [ItemCardView]()
}

struct Masonry: View {
    @EnvironmentObject private var viewModel: ContentVM
    let vertSpacing: CGFloat = 25
    let horizSpacing: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .top, spacing: horizSpacing) {
            ForEach(viewModel.sortedColumns, id: \.self) { colIds in
                LazyVStack(spacing: vertSpacing) {
                    ForEach(colIds, id: \.self) { id in
                        ItemCardView(for: id)
                    }
                }
            }
        }
        .padding(horizSpacing)
    }
}

struct Masonry_Previews: PreviewProvider {
    static var previews: some View {
        Masonry()
    }
}
