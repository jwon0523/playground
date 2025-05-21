//
//  TokenResponse.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/21/25.
//

import Foundation

struct TokenResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserInfo
}
