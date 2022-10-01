//
//  ItemCardView.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 9/30/22.
//

import SwiftUI

struct ItemCardView: View, Identifiable {
    let id = UUID()
    let imageStr: String
    init(for imageStr: String) {
        self.imageStr = imageStr
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(imageStr)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading) {
                    Text(imageStr)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: 250, alignment: .leading)
                    Text("Size: 6")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: 200, alignment: .leading)
                }
                Spacer()
                Text("$8")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("Dark Pink"))
                    .frame(maxWidth: 100, alignment: .trailing)
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}

struct ItemCardView_Previews: PreviewProvider {
    static var previews: some View {
        ItemCardView(for: "sweater_preview")
    }
}
