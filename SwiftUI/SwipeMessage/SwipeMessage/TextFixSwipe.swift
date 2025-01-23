//
//  TextFixSwipe.swift
//  SwipeMessage
//
//  Created by jaewon Lee on 3/19/24.
//

import SwiftUI

struct TextFixSwipe: View {
    var message: String
    @State var showReplyIcon = false
    @State var dragOffset: CGSize = .zero
    @State var moveLeft = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack {
                    VStack(alignment: .trailing) {
                        HStack {
                            Text(message)
                                .padding()
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .background(.yellow)
                        }
                        .frame(maxWidth: 250, alignment: .trailing)
                        .background(.blue)
                    }
                    .padding()
                    .background(.green)
                    // 왼쪽으로 당기면 x축으로 전체 width범위의 10%까지만 왼쪽으로 이동
                    .offset(x: moveLeft ? -geometry.size.width * 0.1 : 0)
                    .animation(.default)
                    // 왼쪽으로 당기는 제스처
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onChanged { value in
                                self.dragOffset = value.translation
                                if self.dragOffset.width < 0 {
                                    // 애니메이션으로 부드럽게 보여줌
                                    withAnimation {
                                        self.showReplyIcon = true
                                        self.moveLeft = true
                                    }
                                } else if self.dragOffset.width > 0 {
                                    // 애니메이션으로 부드럽게 보여줌
                                    withAnimation {
                                        self.showReplyIcon = false
                                        self.moveLeft = false
                                    }
                                }
                            }
                            .onEnded { _ in
                                self.dragOffset = .zero
                                // 여기에 답장 보내는 코드를 추가 가능.
                                print(geometry.size.width)
                            }
                    )
                    if showReplyIcon {
                        HStack {
                            Image(systemName: "square.and.arrow.up.fill")
                                .frame(width: 35, height: 35)
                                .background(.gray)
                                .cornerRadius(20)
                                .shadow(radius: 2.8)
                            Spacer()
                                .frame(width: 8)
                            Image(systemName: "square.and.arrow.up.fill")
                                .frame(width: 35, height: 35)
                                .background(.gray)
                                .cornerRadius(20)
                                .shadow(radius: 2.8)
                            Spacer()
                                .frame(width: 8)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .background(.red)
            }
            .padding(.vertical, 10)
        }
    }
}

#Preview {
    TextFixSwipe(message: "HelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello")
}
