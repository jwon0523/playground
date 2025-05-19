//
//  ContentsViewModel.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/19/25.
//

import Foundation
import Moya

@Observable
class ContentsViewModel {
    var userData: UserData?
    let provider: MoyaProvider<UserRotuer>
    
    init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        self.provider = MoyaProvider<UserRotuer>(plugins: [logger])
    }
    
//    func getUserData(name: String) {
//        provider.request(.getPerson(name: name), completion: { [weak self] result in
//            switch result {
//            case .success(let response):
//                do {
//                    let decodedData = try JSONDecoder().decode(UserData.self, from: response.data)
//                    self?.userData = decodedData
//                } catch {
//                    print("유저 데이터 디코더 오류", error)
//                }
//            case .failure(let error):
//                print("error", error)
//            }
//        })
//    }
    
    /// async/await 문법 적용
    func getUser(name: String) async {
        do {
            let response = try await provider.requestAsync(.getPerson(name: name))
            /// response.data를 파싱해서, 해당 데이터를 UserData라는 Codable 구조체로 변환(디코딩)하여 인스턴스로 만들어줌.
            let user = try JSONDecoder().decode(UserData.self, from: response.data)
            print("유저", user)
        } catch {
            print("요청 또는 디코딩 실패:", error.localizedDescription)
        }
    }
    
    func createUser(_ userData: UserData) {
        provider.request(.postPerson(userData: userData)) { result in
            switch result {
            case .success(let response):
                print("POST 성공: \(response.statusCode)")
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func updateUserPatch(_ patchData: UserPatchRequest) {
        provider.request(.patchPerson(patchData: patchData)) { result in
            switch result {
            case .success(let response):
                print("PATCH 성공: \(response.statusCode)")
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func updateUserPut(_ userData: UserData) {
        provider.request(.putPerson(userData: userData)) { result in
            switch result {
            case .success(let response):
                print("PUT 성공: \(response.statusCode)")
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func deleteUser(name: String) {
        provider.request(.deletePerson(name: name)) { result in
            switch result {
            case .success(let response):
                print("DELETE 성공: \(response.statusCode)")
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
