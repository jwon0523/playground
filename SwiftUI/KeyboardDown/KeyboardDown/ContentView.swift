//
//  ContentView.swift
//  KeyboardDown
//
//  Created by jaewon Lee on 3/24/24.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            TextField("여기에 입력하세요", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("키보드 내리기") {
                UIApplication.shared.endEditing()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
