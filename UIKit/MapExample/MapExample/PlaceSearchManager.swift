//
//  PlaceSearchManager.swift
//  MapExample
//
//  Created by jaewon Lee on 1/20/25.
//

import Foundation

struct LocalPlace {
    let name: String       // 장소명
    let category: String   // 카테고리
    let address: String    // 주소
    let roadAddress: String // 도로명 주소
    let distance: String?  // 거리 (미터, 선택적)
}

// Lng: 127.010581
// Lat: 37.582848

class PlaceSearchManager {
    static let shared = PlaceSearchManager()
    
    // TODO: 클라이언트 아이디 xcconfig 파일로 옮기기
    func fetchLocalPlaces(query: String, completion: @escaping ([LocalPlace]?) -> Void) {
        let clientId = ""        // 네이버 클라이언트 ID
        let clientSecret = "" // 네이버 클라이언트 Secret
        
        // URL 생성
        let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(query)&display=10&sort=random"
        guard let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURLString) else {
            print("URL 생성 실패")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(clientId, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API 호출 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("응답 데이터가 없습니다.")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let items = json["items"] as? [[String: Any]] {
                    
                    let places: [LocalPlace] = items.compactMap { item in
                        guard let name = item["title"] as? String,
                              let category = item["category"] as? String,
                              let address = item["address"] as? String,
                              let roadAddress = item["roadAddress"] as? String else {
                            return nil
                        }
                        
                        return LocalPlace(
                            name: name.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: ""),
                            category: category,
                            address: address,
                            roadAddress: roadAddress,
                            distance: nil // 지역 검색 API는 distance를 제공하지 않음
                        )
                    }
                    print("응답 결과: \(places)")
                    completion(places)
                } else {
                    print("JSON 파싱 실패")
                    completion(nil)
                }
            } catch {
                print("JSON 디코딩 오류: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}
