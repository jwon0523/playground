//
//  MessageSwipe.swift
//  SwipeMessage
//
//  Created by jaewon Lee on 3/19/24.
//

import SwiftUI

struct MessageSwipe: View {
    @State private var showReplyIcon = false
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        HStack {
            Spacer()
            Text("메세지")
                .frame(width: 300, height: 20)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            Spacer()
            if showReplyIcon {
                VStack {
                    Image(systemName: "arrowshape.turn.up.right.fill")
                    // 아이콘 천천히 나타남
                        .transition(.scale)
                }
                .frame(width: 30, height: 20)
                .padding()
                .background(Color.blue)
                .cornerRadius(5)
                
                Spacer()
                    .frame(width: 30)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 50)
                .onChanged { value in
                    self.dragOffset = value.translation
                    if self.dragOffset.width < 0 {
                        // 애니메이션으로 부드럽게 보여줌
                        withAnimation {
                            self.showReplyIcon = true
                        }
                    } else if self.dragOffset.width > 0 {
                        // 애니메이션으로 부드럽게 보여줌
                        withAnimation {
                            self.showReplyIcon = false
                        }
                    }
                }
                .onEnded { _ in
                    self.dragOffset = .zero
                    // 여기에 답장 보내는 코드를 추가 가능.
                }
        )
    }
}

#Preview {
    MessageSwipe()
}
