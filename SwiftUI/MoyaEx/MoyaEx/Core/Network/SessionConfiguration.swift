//
//  SessionConfiguration.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/21/25.
//

import Foundation

/// 네트워크 세션 설정을 위한 클래스
final class SessionConfiguration {
    
    init() {}
    
    static func withCaching() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        // 캐시 정책: 캐시가 있으면 사용, 없으면 서버 요청
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        // 메모리 10MB, 디스크 50MB로 설정된 캐시 객체 등록
        configuration.urlCache = URLCache(
            memoryCapacity: 10 * 1024 * 1024,  // 10MB
            diskCapacity: 50 * 1024 * 1024,    // 50MB
            diskPath: "urlCache"
        )
        
        return configuration
    }
    
    static func withTimeout(_ timeout: TimeInterval) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
//        configuration.headers = .default // Moya에서 헤더 붙이면 되므로 불필요
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        return configuration
    }
}
