//
//  AccessTokenRefresher.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/21/25.
//

import Foundation
import Alamofire

class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {
    private var tokenProviding: TokenProviding
    private var isRefreshing: Bool = false
    private var requestToRetry: [(RetryResult) -> Void] = []
    
    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }
    
    /// 네트워크 요청이 서버로 전송되기 전에 해당 URLRequest를 가로채서 수정(adapt)할 수 있도록 해준다.
    /// 주로 사용되는 경우는 다음과 같다.
    /// 1. 공통 헤더 추가
    /// ex) 모든 요청에 Authorization 헤더를 자동으로 붙이고 싶을 때
    /// 2. 파라미터나 쿼리 수정
    /// ex)공통 쿼리 파라미터를 매 요청마다 추가
    /// 3. 특정 API만 다른 방식으로 처리
    /// ex) 특정 URL일 때만 헤더를 다르게 구성
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var urlRequest = urlRequest
        // 요청에 Authorization 헤더 추가
        if let accessToken = tokenProviding.accessToken {
            urlRequest.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }
        completion(.success(urlRequest))
    }
    
    /// 요청이 실패한 경우, 이 요청을 재시도할지 말지를 결정하는 역할을 한다.
    /// 즉, 자동 재시도 로직을 구현할 수 있는 hook이다.
    /// 해당 메서드를 통해 다음과 같은 동작을 결정할 수 있다.
    /// - 다시 요청을 보낼 것인지(.retry)
    /// - 재시도하지 않고 실패로 끝낼 것인지(.doNotRetry)
    /// - 일정 시간 후 재시도할 것인지(.retryWithDelay(ItmeInterval))
    ///
    /// [주로 사용하는 방법]
    /// 1. 토큰 만료 -> 리프레시 후 재시도
    /// - 401 Unauthorized 응답을 받았을 때 토큰을 갱시한고 요청을 다시 시도
    /// 2. 일시적인 네트워크 오류 -> 재시도
    /// - ex) 인터넷 연결 문제, 타임아웃 등
    /// 3. 서버 오류 응답에 따른 재시도
    /// - ex) 500 Internal Server Error 발생 시 일정 횟수까지 재시도
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: any Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        guard request.retryCount < 1, // 이미 한번 재시도한 요청이라면 다시는 하지 않겠다는 의미
              // 401, 404 인 경우에만 토큰 갱신을 재시도
              let response = request.task?.response as? HTTPURLResponse,
              [401, 404].contains(response.statusCode) else {
            // 조건 불만족시 재시도 하지 않고 종료
            return completion(.doNotRetry)
        }
        // 토큰을 아직 갱신 중이므로 지금 당장 재시도할 수 없으므로,
        // 토큰 갱신이 완료된 후 일괄 처리하기 위해 배열에 잠시 보관해둠
        requestToRetry.append(completion)
        
        /// 현재 토큰 갱신 중인지 여부 확인
        /// 이미 갱신 중이라면 새로운 요청 보내지 않고 기다리기만 함(중복 방지)
        if !isRefreshing {
            isRefreshing = true
            /// refreshToken은 외부에서 주입받은 의존성(tokenProviding)으로, 토큰을 비동기적으로 갱신
            /// 즉, 서버에 갱신 요청을 보내고, 새 토큰 또는 에러를 받아옴
            tokenProviding.refreshToken { [weak self] newToken, error in
                guard let self = self else { return }
                self.isRefreshing = false // 토큰 갱신 완료 후 상태 복원
                let result = error == nil
                // 토큰 갱신 성공시, 실패한 요청들 재시도
                ? RetryResult.retry
                // 토큰 갱신 실패시, 에러 전달 후 요청 종료
                : RetryResult.doNotRetryWithError(error!)
                // 배열에 저장되어 있던 모든 실패 요청들의 completion 핸들러를 호출하여 재시도하거나 종료
                self.requestToRetry.forEach { $0(result) }
                self.requestToRetry.removeAll() // 재사용 위한 초기화
            }
        }
    }
}
