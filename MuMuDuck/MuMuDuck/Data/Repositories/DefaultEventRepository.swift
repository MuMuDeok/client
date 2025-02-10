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
            PersonalEvent(title: "테스트A", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 13), endDate: getDate(year: 2025, month: 02, day: 19), isAlert: true, memo: "테스트 메모A"),
            PersonalEvent(title: "테스트B", isAllDay: false, startDate: getDate(year: 2025, month: 01, day: 27), endDate: getDate(year: 2025, month: 01, day: 30), isAlert: true, memo: "테스트 메모B"),
            PersonalEvent(title: "테스트C", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 19), endDate: getDate(year: 2025, month: 02, day: 25), isAlert: false, memo: "테스트 메모C"),
            PersonalEvent(title: "테스트D", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 23), endDate: getDate(year: 2025, month: 02, day: 25), isAlert: false, memo: "테스트 메모D"),
            PersonalEvent(title: "테스트E", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 19), endDate: getDate(year: 2025, month: 02, day: 28), isAlert: false, memo: "테스트 메모E"),
            PersonalEvent(title: "테스트F", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 12), endDate: getDate(year: 2025, month: 02, day: 23), isAlert: false, memo: "테스트 메모F"),
            PersonalEvent(title: "테스트G", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 25), endDate: getDate(year: 2025, month: 3, day: 1), isAlert: false, memo: "테스트 메모G"),
        ]
    }
    
    func fetchEvents() -> [any Event] {
        return self.events
    }
}
