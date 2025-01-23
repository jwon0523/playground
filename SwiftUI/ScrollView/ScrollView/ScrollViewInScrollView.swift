//
//  ScrollViewInScrollView.swift
//  ScrollView
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct ScrollViewInScrollView: View {
    var body: some View {
        // 기본적으로 ScrollView는 vertical로 구성되어 있음
        // ScrollView안에 ScrollView를 넣어주어 기본적으로는 수직으로 스크롤 하되
        // 각 행은 horizontal로 스크롤하게 할 수 있음
        ScrollView {
            VStack {
                ForEach(0..<20) { index in
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        HStack {
                            ForEach(0..<10)  { _ in
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(width: 200, height: 150)
                                    .shadow(radius: 10)
                                    .padding()
                            }
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    ScrollViewInScrollView()
}
