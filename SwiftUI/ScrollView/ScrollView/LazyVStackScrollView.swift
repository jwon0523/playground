//
//  LazyVStackScrollView.swift
//  ScrollView
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct LazyVStackScrollView: View {
    var body: some View {
        // 아이템이 20~30개와 같이 적은 수인 경우에는 ForEach로 작성해도 괜찮지만
        // 만약 100개 이상의 많은 아이템을 로드해야 할 경우 시간이 오래 걸릴 수 있음
        // 이럴 때 사용하는 것이 LazyVStack임
        // Lazy는 스크롤 할 때 그 화면에 보이는 아이템이 동시에 다운로드 됨.
        // 이런 이유로 광대한 데이터 사용 막아 줄 수 있음
        ScrollView {
            LazyVStack {
                ForEach(0..<20) { index in
                    ScrollView(.horizontal, showsIndicators: false, content: {
                        LazyHStack {
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
    LazyVStackScrollView()
}
