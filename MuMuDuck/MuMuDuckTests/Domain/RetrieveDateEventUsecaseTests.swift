//
//  RetrieveDateEventUsecaseTests.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import XCTest
@testable import MuMuDuck

final class RetrieveDateEventUsecaseTests: XCTestCase {
    
    var mockEvents: [any Event] = []
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockEvents = [
            PersonalEvent(title: "테스트1", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 8), endDate: getDate(year: 2025, month: 2, day: 9), isAlert: false),
            PersonalEvent(title: "테스트2", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 10), endDate: getDate(year: 2025, month: 2, day: 13), isAlert: false),
            PersonalEvent(title: "테스트3", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 12), endDate: getDate(year: 2025, month: 2, day: 13), isAlert: false),
            PersonalEvent(title: "테스트4", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 18), endDate: getDate(year: 2025, month: 2, day: 20), isAlert: false),
            PersonalEvent(title: "테스트5", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 21), endDate: getDate(year: 2025, month: 2, day: 21), isAlert: false),
        ]
    }
    
    func test_whenRetriveEventWithDate_thenReturnEventIncludeDate() {
        // given
        let repository = DefaultEventRepository(events: mockEvents)
        let usecase = RetrieveDateEventUsecase(eventRepository: repository)
        let date = getDate(year: 2025, month: 2, day: 21)
        
        // when
        let retrivedEvents = usecase.execute(date: date)
        
        // then
        XCTAssertEqual(retrivedEvents.count, 1)
        XCTAssertEqual(retrivedEvents[0] as! PersonalEvent, mockEvents[4] as! PersonalEvent)
    }
    
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
}
