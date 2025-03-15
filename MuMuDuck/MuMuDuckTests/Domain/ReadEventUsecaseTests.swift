//
//  ReadEventUsecaseTests.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import XCTest
@testable import MuMuDuck

final class ReadEventUsecaseTests: XCTestCase {
    
    let repositoryMock = DefaultEventRepository.shared
    
    func test_whenReadEventWithId_thenReturnWhichIdisSame() {
        // given
        let createUsecase = CreateEventUsecase()
        let readUsecase = ReadEventUsecase()
        
        let title = "test"
        let isAllDay: Bool = false
        let startDate: Date = Date()
        let endDate: Date = Date()
        let alertTime: Int = 5
        let memo: String = "test memo"
        
        createUsecase.execute(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, alertTime: alertTime, memo: memo)
        let id = repositoryMock.events.last!.id
        
        // when
        let event = readUsecase.execute(id: id)
        
        // then
        XCTAssertEqual(event.title, title)
        XCTAssertEqual(event.isAllDay, isAllDay)
        XCTAssertEqual(event.startDate, startDate)
        XCTAssertEqual(event.endDate, endDate)
        XCTAssertEqual(event.alertTime, alertTime)
    }
}
