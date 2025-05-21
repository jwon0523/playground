//
//  Extensions+MoyaProvider.swift
//  MoyaEx
//
//  Created by jaewon Lee on 5/19/25.
//

import Foundation
import Moya

extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
