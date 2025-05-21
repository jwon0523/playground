//
//  ContentView.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/19/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(ButtonInfoList.buttonList, id: \.id) { button in
                Button(action: {
                    button.action()
                }, label: {
                    Text(button.title)
                })
            }
        }
        .padding()
    }
}

struct ButtonInfo: Identifiable {
    var id: UUID = .init()
    var title: String
    var action: () -> Void
}

final class ButtonInfoList {
    
    static let serviceManager: ContentsViewModel = .init()
    
    static let buttonList: [ButtonInfo] = [
        .init(title: "로그인", action: {
                    serviceManager.loginAndStoreTokens()
                }),
        .init(title: "GET", action: {
            Task {
                await serviceManager.getUser(name: "리버")
            }
        }),
        .init(title: "POST", action: {
            serviceManager.createUser(
                .init(name: "리버", age: 29, address: "서울시 성북구", height: 177))
        }),
        .init(title: "PATCH", action: {
            serviceManager.updateUserPatch(
                .init(name: nil, age: 18, address: nil, height: nil))
        }),
        .init(title: "PUT", action: {
            serviceManager.updateUserPut(
                .init(name: "RIVER", age: 29, address: "서울시", height: 177))
        }),
        .init(title: "DELETE", action: {
            serviceManager.deleteUser(name: "리버")
        }),
    ]
}

#Preview {
    ContentView()
}

