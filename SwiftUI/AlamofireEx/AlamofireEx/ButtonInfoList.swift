//
//  ButtonInfoList.swift
//  AlamofireEx
//
//  Created by jaewon Lee on 5/8/25.
//
import Foundation

struct ButtonInfo: Identifiable {
    var id: UUID = .init()
    var title: String
    var action: () -> Void
}

final class ButtonInfoList {
    
    static let serviceManager: ServiceManager = .init()
    
    static let buttonList: [ButtonInfo] = [
        .init(title: "GET", action: {
            Task {
                await serviceManager.getUser(name: "리버")
            }
        }),
        .init(title: "POST", action: {
            Task {
                await serviceManager.postUser(
                    user: .init(name: "리버", age: 29, address: "서울시 성북구", height: 177))
                
            }
        }),
        .init(title: "PATCH", action: {
            Task {
                await serviceManager.patchUser(name: "River")
            }
        }),
        .init(title: "PUT", action: {
            Task {
                await serviceManager.putUser(
                    user: .init(name: "리버", age: 20, address: "서울시 강북구", height: 190))
            }
        }),
        .init(title: "DELETE", action: {
            Task {
                await serviceManager.deleteUser(name: "리버")
            }
        }),
    ]
}
