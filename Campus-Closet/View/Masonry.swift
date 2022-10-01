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
    let vertSpacing: CGFloat = 25
    let horizSpacing: CGFloat = 10
    
    let columns = [
        Column(items: [
            ItemCardView(for: "jeans"),
            ItemCardView(for: "shorts"),
            ItemCardView(for: "crop top"),
            ItemCardView(for: "top"),
            ItemCardView(for: "dress"),
        ]),
        Column(items: [
            ItemCardView(for: "sweater"),
            ItemCardView(for: "pants"),
            ItemCardView(for: "skirt"),
            ItemCardView(for: "blouse")
        ]),
    ]
    
    var body: some View {
        HStack(alignment: .top, spacing: horizSpacing) {
            ForEach(columns) { column in
                LazyVStack(spacing: vertSpacing) {
                    ForEach(column.items) { item in
                        item
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
