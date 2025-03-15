//
//  UpdateEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import XCTest
@testable import MuMuDuck

final class UpdateEventUsecaseTests: XCTestCase {
    
    let repositoryMock = DefaultEventRepository.shared
    
    func test_whenGiveEvent_thenSameIdEventWillUpdate() {
        // given
        let createUsecase = CreateEventUsecase()
        let readUsecase = ReadEventUsecase()
        let updateUsecase = UpdateEventUsecase()
        
        let title = "test"
        let isAllDay: Bool = false
        let startDate: Date = Date()
        let endDate: Date = Date()
        let alertTime: Int = 5
        let memo: String = "test memo"
        
        createUsecase.execute(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, alertTime: alertTime, memo: memo)
        // when
        let id = repositoryMock.events.last!.id
        let newTitle = "new Title"
        let newIsAllDay: Bool = true
        let newStartDate: Date = Date()
        let newEndDate: Date = Date()
        let newAlertTime: Int = 10
        let newMemo: String = "new memo"
        let newEvent = PersonalEvent(id: id, title: newTitle, isAllDay: newIsAllDay, startDate: newStartDate, endDate: newEndDate, alertTime: newAlertTime, memo: newMemo)
        
        updateUsecase.execute(event: newEvent)
        let event = readUsecase.execute(id: id)
        
        // then
        XCTAssertEqual(event.title, newTitle)
        XCTAssertEqual(event.isAllDay, newIsAllDay)
        XCTAssertEqual(event.startDate, newStartDate)
        XCTAssertEqual(event.endDate, newEndDate)
        XCTAssertEqual(event.alertTime, newAlertTime)
    }
}
