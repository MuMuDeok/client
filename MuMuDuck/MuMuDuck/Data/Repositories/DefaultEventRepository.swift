//
//  DefaultEventRepository.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

@Observable
class DefaultEventRepository: EventRepository {
    static let shared: DefaultEventRepository = DefaultEventRepository()
    
    var events: [any Event]
    
    init(events: [any Event] = []) {
        // 목 데이터를 위한 임시 함수
        func getDate(year: Int, month: Int, day: Int) -> Date {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            if let date = Calendar.current.date(from: dateComponents) {
                return date
            } else {
                return Date()
            }
        }
        
        self.events = [
            PersonalEvent(title: "테스트1", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 8), endDate: getDate(year: 2025, month: 2, day: 9), isAlert: false),
            PersonalEvent(title: "테스트2", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 10), endDate: getDate(year: 2025, month: 2, day: 13), isAlert: false),
            PersonalEvent(title: "테스트3", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 12), endDate: getDate(year: 2025, month: 2, day: 13), isAlert: false),
            PersonalEvent(title: "테스트4", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 18), endDate: getDate(year: 2025, month: 2, day: 20), isAlert: false),
            PersonalEvent(title: "테스트5", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 21), endDate: getDate(year: 2025, month: 2, day: 21), isAlert: false),
        ]
    }
    
    func fetchEvents() -> [any Event] {
        return self.events
    }
}
