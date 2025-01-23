//
//  ContentView.swift
//  ScrollView
//
//  Created by jaewon Lee on 5/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach(1..<100) {
                    Text("Item \($0)") //$표시 필수
                        .font(.title)
                }
            } //VStack
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    ContentView()
}
