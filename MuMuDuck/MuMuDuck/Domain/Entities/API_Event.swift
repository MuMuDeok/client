//
//  API_Event.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import Foundation

// API 통신을 위한 Entity
struct EventToAPIEvent: Codable {
    let userId: Int
    let title: String
    let isAllDay: Bool
    let startDate: Date
    let endDate: Date
    let memo: String
    let type: Int
    
    // 추후 이벤트별로 초기화 함수 추가
    init(userId: Int, event: PersonalEvent) {
        self.userId = userId
        self.title = event.title
        self.isAllDay = event.isAllDay
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.memo = event.memo
        self.type = 1
    }
    
    init(userId: Int, failed_event: Failed_Event) {
        self.userId = userId
        self.title = failed_event.title
        self.isAllDay = failed_event.isAllDay
        self.startDate = failed_event.startDate
        self.endDate = failed_event.endDate
        self.memo = failed_event.memo ?? ""
        self.type = 1
    }
}
