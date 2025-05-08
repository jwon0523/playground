//
//  RequestRetrierHandler.swift
//  AlamofireEx
//
//  Created by jaewon Lee on 5/8/25.
//

import Alamofire
import Foundation

protocol TokenProviding: Sendable {
    var accessToken: String? { get }
}

final class RequestRetrierHandler: RequestInterceptor {
    
    private let tokenProviding: TokenProviding
    
    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }

    // 1. 요청에 Authorization 헤더 추가
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        
        if let accessToken = tokenProviding.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(urlRequest))
    }

    // 2. 401 에러 발생 시 재시도
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if let response = request.task?.response as? HTTPURLResponse,
           response.statusCode == 401 {
            print("401 에러, 재시도 수행")
            completion(.retry)
        } else {
            completion(.doNotRetry)
        }
    }
}
