//
//  UserData.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/21/25.
//

import Foundation

struct UserData: Codable {
    let name: String
    let age: Int
    let address: String
    let height: Double
}

struct UserPatchRequest: Codable {
    let name: String?
    let age: Int?
    let address: String?
    let height: Double?
}
