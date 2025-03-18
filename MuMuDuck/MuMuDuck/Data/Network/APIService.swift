//
//  APIService.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func createEvent(event: EventToAPIEvent) async throws -> Bool {
        guard let api_url = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else { return false }
        
        guard let url = URL(string: "\(api_url)/v1/users/schedule") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try JSONEncoder().encode(event)
        request.httpBody = jsonData

        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.unknown)
        }

        if (200...299).contains(httpResponse.statusCode) {
            print("✅ 이벤트 생성 성공!")
            return true
        } else {
            print("❌ 이벤트 생성 실패, 상태 코드: \(httpResponse.statusCode)")
            return false
        }
    }
}
