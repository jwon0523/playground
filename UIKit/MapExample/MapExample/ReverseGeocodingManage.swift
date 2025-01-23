//
//  ReverseGeocodingManage.swift
//  MapExample
//
//  Created by jaewon Lee on 1/20/25.
//

import Foundation

struct AddressInfo {
    let lawDistrict: String
    let adminDistrict: String
    let landAddress: String?
    let roadAddress: String?
}

class ReverseGeocodingManage {
    static let shared = ReverseGeocodingManage()
    func fetchAddress(latitude: Double, longitude: Double, completion: @escaping (AddressInfo?) -> Void) {
        let clientId = ""
        let clientSecret = ""
        
        let urlString = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(longitude),\(latitude)&output=json&orders=addr,roadaddr"
        guard let url = URL(string: urlString) else {
            print("잘못된 URL 입니다.")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(clientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
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
                   let results = json["results"] as? [[String: Any]] {
                    
                    var lawDistrict = ""
                    var adminDistrict = ""
                    var landAddress: String?
                    var roadAddress: String?
                    print(results)
                    
                    for result in results {
                        if let region = result["region"] as? [String: Any] {
                            // 법정동, 행정동 추출
                            lawDistrict = (region["area3"] as? [String: Any])?["name"] as? String ?? lawDistrict
                            adminDistrict = (region["area2"] as? [String: Any])?["name"] as? String ?? adminDistrict
                        }
                        
                        if let land = result["land"] as? [String: Any] {
                            // 지번 주소 추출
                            if let name = land["name"] as? String {
                                let number1 = land["number1"] as? String ?? ""
                                let number2 = land["number2"] as? String ?? ""
                                landAddress = "\(name) \(number1)\(number2.isEmpty ? "" : "-\(number2)")"
                            }
                        }
                        
                        if let roadAddr = result["land"] as? [String: Any],
                           let roadName = roadAddr["name"] as? String {
                            // 도로명 주소 추출
                            roadAddress = roadName
                        }
                    }
                    
                    let addressInfo = AddressInfo(
                        lawDistrict: lawDistrict,
                        adminDistrict: adminDistrict,
                        landAddress: landAddress,
                        roadAddress: roadAddress
                    )
                    completion(addressInfo)
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
