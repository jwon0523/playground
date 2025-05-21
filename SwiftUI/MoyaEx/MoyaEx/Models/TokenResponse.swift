//
//  TokenResponse.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/21/25.
//

import Foundation

struct TokenResponse: Codable {
    var accessToken: String
    var refreshToken: String
}
