//
//  VerticalAndHorizontalScrollView.swift
//  ScrollView
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct VerticalAndHorizontalScrollView: View {
    var body: some View {
        // 스크롤 바가 나타나지 않음
        // 스크롤 방향은 vertical과 horizontal을 선택하면 되는데,
        // vertical 선택시 자식 뷰로 VStack을 선택해 줘야 하고
        // horiznotal 선택시 자식 뷰로 HStack을 선택해 줘야 함
        ScrollView(.vertical, showsIndicators: false, content:  {
            VStack {
                ForEach(0..<50) { index in
                    Circle()
                        .fill(Color.red)
                        .frame(height: 100)
                        .overlay(Text("vertical").foregroundColor(.white))
                }
            }
        })
        
        Divider()
        
        ScrollView(.horizontal, showsIndicators: false, content:  {
            HStack {
                ForEach(0..<50) { index in
                    Circle()
                        .fill(Color.red)
                        .frame(width: 100)
                        .overlay(Text("horizontal").foregroundColor(.white))
                }
            }
        })

    }
}

#Preview {
    VerticalAndHorizontalScrollView()
}
