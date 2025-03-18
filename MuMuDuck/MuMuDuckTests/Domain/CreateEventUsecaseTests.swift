//
//  CreateEventUsecaseTests.swift
//  MuMuDuckTests
//
//  Created by 강승우 on 2/12/25.
//

import XCTest
@testable import MuMuDuck

final class CreateEventUsecaseTests: XCTestCase {
    
    let repositoryMock = DefaultEventRepository.shared
    
    func test_whenCreateEvent_thenRepositoryEventCreateNewEvent() {
        // given
        let usecase = CreateEventUsecase()
        
        // when
        let title = "test"
        let isAllDay: Bool = false
        let startDate: Date = Date()
        let endDate: Date = Date()
        let alertTime: Int = 5
        let memo: String = "test memo"
        
        let beforeCreateEventCount = repositoryMock.events.count
        usecase.execute(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, alertTime: alertTime, memo: memo)
        let afterCreateEventCount = repositoryMock.events.count
        
        // then
        XCTAssertEqual(beforeCreateEventCount + 1, afterCreateEventCount)
        XCTAssertEqual(repositoryMock.events.last?.title, title)
        XCTAssertEqual(repositoryMock.events.last?.isAllDay, isAllDay)
        XCTAssertEqual(repositoryMock.events.last?.startDate, startDate)
        XCTAssertEqual(repositoryMock.events.last?.endDate, endDate)
        XCTAssertEqual(repositoryMock.events.last?.alertTime, alertTime)
    }
}
