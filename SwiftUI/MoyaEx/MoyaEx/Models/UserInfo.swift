//
//  UserInfo.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/21/25.
//

import Foundation

struct UserInfo: Codable {
    // 토큰의 부분 업데이트 혹은 디코드 실패시 키 값이 저장 안될 경우를 대비하기 위해서이다.
    // 네트워크를 통해 토큰값 초기화하게 될 것이기 때문에, 네트워크 오류를 생각해두고 만들어야한다.
    var accessToken: String?
    var refreshToken: String?
}
