//
//  TagsList.swift
//  Campus-Closet
//
//  Displays a wraparound list of tags
//
//  Created by Olivia Logan on 10/22/22.
//
//  Copyright note: Most code taken from: https://stackoverflow.com/questions/62102647/swiftui-hstack-with-wrap-and-dynamic-height/62103264#62103264
//

import SwiftUI

struct TagsList: View {
    @EnvironmentObject private var viewModel: PostVM
    @State private var totalHeight = CGFloat.infinity

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(maxHeight: totalHeight) // << variant for VStack
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(viewModel.item.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == viewModel.item.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == viewModel.item.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .padding(.all, 5)
            .font(.body)
            .background(Color("Dark Pink"))
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }

}

struct Tag: View {
    private var tag: String
    init(for tag: String) {
        self.tag = tag
    }
    
    var body: some View {
        Text(tag)
            .padding(5)
            .font(.body)
            .background(Color("Dark Pink"))
            .foregroundColor(Color.white)
            .cornerRadius(5)
    }
}

struct TagsList_Previews: PreviewProvider {
    static var previews: some View {
        TagsList()
    }
}
