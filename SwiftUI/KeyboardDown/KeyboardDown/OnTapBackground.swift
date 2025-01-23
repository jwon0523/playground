//
//  DownBtnInKeyboard.swift
//  KeyboardDown
//
//  Created by jaewon Lee on 3/24/24.
//

import SwiftUI

struct OnTapBackground: View {
    @State private var text = ""

    var body: some View {
        VStack {
            TextField("여기에 입력하세요", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()
                .background(.red)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
        }
        .padding()
    }
}


#Preview {
    OnTapBackground()
}
