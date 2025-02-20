//
//  RetrieveDateEventUsecaseTests.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import XCTest
@testable import MuMuDuck

final class RetrieveDateEventUsecaseTests: XCTestCase {
    
    let repositoryMock = DefaultEventRepository.shared
    
    func test_whenRetriveEventWithDate_thenReturnEventIncludeDate() {
        // given
        let repository = DefaultEventRepository()
        let usecase = RetrieveDateEventUsecase()
        let date = getDate(year: 2025, month: 2, day: 21)
        
        // when
        let retrivedEvents = usecase.execute(date: date)
        
        // then
        XCTAssertEqual(retrivedEvents.count, 3)
        XCTAssertEqual(retrivedEvents[0] as! PersonalEvent, repositoryMock.events[2] as! PersonalEvent)
        XCTAssertEqual(retrivedEvents[1] as! PersonalEvent, repositoryMock.events[4] as! PersonalEvent)
        XCTAssertEqual(retrivedEvents[2] as! PersonalEvent, repositoryMock.events[5] as! PersonalEvent)
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
