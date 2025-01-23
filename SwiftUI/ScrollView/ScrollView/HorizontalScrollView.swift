//
//  HorizontalScrollView.swift
//  ScrollView
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct HorizontalScrollView: View {
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<10) {
                    Text("숫자 \($0)")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .background(Color.yellow)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    HorizontalScrollView()
}
