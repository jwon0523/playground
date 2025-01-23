//
//  ContentView.swift
//  ScrollViewReader
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct ContentView: View {
    @Namespace var topID
    @Namespace var bottomID
    @State var isTapped: Bool = false
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                Button("Scroll to Bottom") {
                    withAnimation {
//                        isTapped.toggle()
                        proxy.scrollTo(bottomID)
                    }
                }
                .id(topID)
                
                VStack(spacing: 0) {
                    ForEach(0..<100) { i in
                        color(fraction: Double(i) / 100)
                            .frame(height: 32)
                        
                        if isTapped {
                            VStack {
                                Text("이상한걸 보여드리겠습니다.")
                                Text("눈뜨고 지켜봐주세요!")
                                Text("버튼은 어디에..?")
                            }
                        }
                    }
                }
                
                Button("Top") {
                    withAnimation {
                        proxy.scrollTo(topID)
                    }
                }
                .id(bottomID)
            }
        }
    }
}

func color(fraction: Double) -> Color {
    Color(red: fraction, green: 1 - fraction, blue: 0.5)
}


#Preview {
    ContentView()
}
