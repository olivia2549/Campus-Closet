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

@MainActor protocol HandlesTagsVM: ObservableObject {
    var tags: [String] { get set }
    var tagsLeft: [String: Int] { get set }
    func addTag(for tag: String)
    func removeTag(for tag: String)
}

// Structure that manages a list of tags used in filtering.
struct TagsList<ViewModel>: View where ViewModel: HandlesTagsVM {
    @EnvironmentObject private var viewModel: ViewModel
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
            ForEach(viewModel.tags, id: \.self) { tag in
                self.createTag(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == viewModel.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == viewModel.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func createTag(for tag: String) -> some View {
        Text(tag)
            .padding(5)
            .font(.body)
            .background(Styles().themePink)
            .foregroundColor(Color.white)
            .cornerRadius(5)
            .onTapGesture {
                viewModel.removeTag(for: tag)
            }
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
