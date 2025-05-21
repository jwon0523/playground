//
//  UserRouter.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/19/25.
//

import Foundation
import Moya

enum UserRotuer {
    case getPerson(name: String)
    case postPerson(userData: UserData)
    case patchPerson(patchData: UserPatchRequest)
    case putPerson(userData: UserData)
    case deletePerson(name: String)
}

extension UserRotuer: APITargetType {
    var path: String {
        return "/person"
    }
    
    var method: Moya.Method {
        switch self {
        case .getPerson:
            return .get
        case .postPerson:
            return .post
        case .patchPerson:
            return .patch
        case .putPerson:
            return .put
        case .deletePerson:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getPerson(let name), .deletePerson(let name):
            /// `queryString`
            /// - 무조건 URL 쿼리 문자열 추가
            /// - GET, DELETE 등
            /// - 파라미터 위치 ?key=value&... 형태로 URL 뒤에 붙음
            ///
            /// `default`
            /// - GET 요청이면 query, 그 외는 HTTP body
            /// - GET, POST, PATCH, PUT, DELETE 등
            /// - 파라미터 위치: 자동 판단 (GET → URL, 나머지 → body)
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.queryString)
        case .postPerson(let userData), .putPerson(let userData):
            ///`RequestBody`에서 사용한 `requestJSONEncodable`는
            /// Encodable 모델을 JSON으로 자동 변환하여 body에 넣는 가장 깔끔한 방법
            /// 복잡한 파라미터가 많거나, API 스팩이 자주 바뀌는 상황에서 특히 유리
            return .requestJSONEncodable(userData)
        case .patchPerson(let patchData):
            return .requestJSONEncodable(patchData)
        }
    }
}
