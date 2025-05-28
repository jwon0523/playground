//
//  CombineViewModel.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/28/25.
//

import Foundation
import CombineMoya
import Combine
import Moya
import os

class CombineViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    private let provider: MoyaProvider<UserRotuer>
    
    private let logger = Logger(subsystem: "edu.river.MoyaEx", category: "CombineViewModel")
    
    @Published var userName: String = ""
    @Published var isLoading: Bool = false
    @Published var userData: UserData? = nil
    
    init(provider: MoyaProvider<UserRotuer> = APIManager.shared.createProvider(for: UserRotuer.self)) {
        
        self.provider = provider
        //    .debounce    사용자가 입력을 멈춘 뒤 400ms 이후에만 동작 (API 과잉 호출 방지)
        //    .removeDuplicates()
        //    .filter    빈 문자열은 무시
        //    .flatMap    이름이 변경될 때마다 getUser(name:) API 요청 실행
        //    .receive(on:)    UI 상태 업데이트를 위해 메인 스레드에서 처리
        $userName
            // 사용자가 입력을 멈춘 뒤 400ms 이후에만 동작 (API 과잉 호출 방지)
            // UX 측면에서 300 ~ 600 사이를 많이 사용
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates() // 이전 값과 같다면 API 호출하지 않음
            .filter { [weak self] in // 빈 문자열은 무시
                self?.logger.debug("입력된 값: \($0)")
                return !$0.isEmpty
            }
            .flatMap { name in // 이름이 변경될 때마다 getUser(name:) API 요청 실행
                self.getUser(name: name)
            }
            .receive(on: DispatchQueue.main) // UI 상태 업데이트를 위해 메인 스레드에서 처리
            .assign(to: &$userData) // 응답받은 값을 userData에 자동 저장 (SwiftUI에서 View 갱신 가능)
    }
    
    // 실패해도 앱이 멈추지 않도록 Never 타입을 명시
    private func getUser(name: String) -> AnyPublisher<UserData?, Never> {
           provider.requestPublisher(.getPerson(name: name))
               .handleEvents(
                   receiveSubscription: { _ in
                       DispatchQueue.main.async {
                           self.isLoading = true
                       }
                   },
                   receiveCompletion: { _ in
                       DispatchQueue.main.async {
                           self.isLoading = false
                       }
                   }
               )
               .map(\.data)
               .decode(type: UserData.self, decoder: JSONDecoder())
               .map { Optional($0) } // 옵셔널로 래핑해서 에러 상황과 동일 타입 유지
               .catch { error -> Just<UserData?> in
                   DispatchQueue.main.async {
                       print("에러: \(error.localizedDescription)")
                   }
                   return Just(nil)
               }
               .eraseToAnyPublisher()
       }
}
