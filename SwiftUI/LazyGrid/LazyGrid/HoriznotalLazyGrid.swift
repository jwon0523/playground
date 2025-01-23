//
//  LazyHGrid.swift
//  LazyGrid
//
//  Created by jaewon Lee on 5/7/24.
//

import SwiftUI

struct HoriznotalLazyGrid: View {
    let rows = [GridItem(.fixed(30)), GridItem(.fixed(30))]


    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(0x1f600...0x1f679, id: \.self) { value in
                    Text(String(format: "%x", value))
                    Text(emoji(value))
                        .font(.largeTitle)
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
    HoriznotalLazyGrid()
}
