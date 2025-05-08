//
//  SSL.swift
//  AlamofireEx
//
//  Created by jaewon Lee on 5/8/25.
//

import Alamofire

class SSL {
    private let session: Session

    init() {
        let evaluators: [String: ServerTrustEvaluating] = [
            "example.com": PinnedCertificatesTrustEvaluator()
        ]
        let trustManager = ServerTrustManager(evaluators: evaluators)
        self.session = Session(serverTrustManager: trustManager)
    }

    func sendRequest() {
        session.request("https://example.com")
            .validate()
            .response { response in
                print("보안 검증된 응답")
            }
    }
}
