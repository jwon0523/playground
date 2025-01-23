//
//  PinnedGridView.swift
//  LazyGrid
//
//  Created by jaewon Lee on 5/8/24.
//

import SwiftUI

struct PinnedGridView: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]


    var body: some View {
         ScrollView {
             LazyVGrid(
                columns: columns,
                spacing: 10,
                pinnedViews: [.sectionHeaders]
             ) {
                 Section(
                    header: Text("첫 번째 섹션")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.green)
                        .foregroundStyle(.white)
                 ) {
                     ForEach(0x1f600...0x1f630, id: \.self) { value in
                         ZStack {
                             RoundedRectangle(cornerRadius: 10)
                                 .frame(width: 150, height: 100)
                                 .foregroundColor(.accentColor)
                             
                             Text(emoji(value))
                                 .font(.largeTitle)
                         }
                     }
                 }
                 
                 Section(
                    header: Text("두 번째 섹션")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.gray)
                        .foregroundStyle(.white)
                 ) {
                     ForEach(0x1f631...0x1f650, id: \.self) { value in
                         ZStack {
                             RoundedRectangle(cornerRadius: 10)
                                 .frame(width: 150, height: 100)
                                 .foregroundColor(.accentColor)
                             
                             Text(emoji(value))
                                 .font(.largeTitle)
                         }
                     }
                 }
             }
         }
    }


    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}

#Preview {
    PinnedGridView()
}
