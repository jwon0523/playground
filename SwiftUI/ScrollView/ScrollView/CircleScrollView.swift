//
//  CircleScrollView.swift
//  ScrollView
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct CircleScrollView: View {
    var body: some View {
        VStack {
            Divider()
            ScrollView(.horizontal) {
                HStack {
                    ForEach(0..<100) { i in
                        CircleView(label: "\(i)")
                            .foregroundColor(.white)
                    }
                }
                .padding()
            }
            .frame(height: 100)
            Divider()
            Spacer()
        }
    }
}
struct CircleView: View {
    @State var label: String
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 70, height: 70)
            Text(label)
        }
    }
}

#Preview {
    CircleScrollView()
}
