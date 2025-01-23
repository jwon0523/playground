//
//  FlexibleLazyGrid.swift
//  LazyGrid
//
//  Created by jaewon Lee on 5/7/24.
//

import SwiftUI

struct FlexibleLazyGrid: View {
    let columns = [GridItem(.flexible())]
    let colors: [Color] = [.black, .blue, .brown, .cyan, .gray, .indigo, .mint, .yellow, .orange, .purple]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(colors, id: \.self) { color in
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 150, height: 100)
                    .foregroundColor(color)
            }
        }
        .padding()
    }
}

#Preview {
    FlexibleLazyGrid()
}
