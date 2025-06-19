//
//  HolidayAPITarget.swift
//  CustomCalendarEx
//
//  Created by jaewon Lee on 6/19/25.
//

import Foundation
import Moya

enum HolidayAPITarget {
    case getHoliday(year: Int)
}

extension HolidayAPITarget: TargetType {
    
    var baseURL: URL {
        let url = URL(string: "http://apis.data.go.kr")!
        return url
    }
    
    var path: String {
        switch self {
        case .getHoliday:
            return "/B090041/openapi/service/SpcdeInfoService/getRestDeInfo"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHoliday:
            return .get
        }
    }
    
    var task: Task {
        var apiKey: String {
            guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
                fatalError("API_KEY not found in Info.plist")
            }
            return apiKey
        }
        switch self {
        case .getHoliday(let year):
            return .requestParameters(parameters: [
                "solYear": year,
                "ServiceKey": apiKey,
                "_type": "json",
                "numOfRows": 20
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
