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
}
