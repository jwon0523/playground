//
//  APITargetType.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/19/25.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var headers: [String: String]? {
        switch task {
        case .requestJSONEncodable, .requestParameters:
            return ["Content-Type": "application/json"]
        case .uploadMultipart:
            return ["Content-Type": "multipart/form-data"]
        default:
            return nil
        }
    }
    
    /// 200대 응답 코드만 성공으로 간주하고 나머지는 모두 실패로 간주
    /// 이렇게 함으로써 200 응답 코드 외에 모두 retry 조건으로 활용 가능함
    var validationType: ValidationType { .successCodes }
}
