//
//  DeleteEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import XCTest
@testable import MuMuDuck

final class DeleteEventUsecaseTests: XCTestCase {
    
    let repositoryMock = DefaultEventRepository.shared
    
    func test_whenGiveEventId_thenSameIdEventWillDelete() {
        // given
        let createUsecase = CreateEventUsecase()
        let deleteUseCase = DeleteEventUsecase()
        
        let title = "test"
        let isAllDay: Bool = false
        let startDate: Date = Date()
        let endDate: Date = Date()
        let alertTime: Int = 5
        let memo: String = "test memo"
        
        createUsecase.execute(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, alertTime: alertTime, memo: memo)
        
        // when
        let beforeEventCount = repositoryMock.events.count
        deleteUseCase.execute(event: repositoryMock.events.last!)
        let afterEventCount = repositoryMock.events.count
        
        // then
        XCTAssertEqual(beforeEventCount - 1, afterEventCount)
    }
}
