//
//  MiniCalendarViewModelTest.swift
//  MuMuDuckTests
//
//  Created by 강승우 on 2/7/25.
//

import XCTest
@testable import MuMuDuck

final class MiniCalendarViewModelTest: XCTestCase {
    func test_whenClickChangeMonthButton_thenChangeMonth() {
        // given
        var dateComponents = DateComponents()
        dateComponents.year = 2025 // 연도를 설정
        dateComponents.month = 5    // 월을 설정
        dateComponents.day = 1      // 일자를 설정 (일자를 설정하지 않으면 기본값이 1로 설정됨)
        
        guard let calendarDate = Calendar.current.date(from: dateComponents) else {
            return XCTFail("Failed to create date from components")
        }
        
        let calendarVM = MiniCalendarViewModel(calendarMonth: calendarDate)
        
        // when
        calendarVM.changeMonth(value: 1) // 다음 달로 변경
        
        // then
        let expectedDateComponents = DateComponents(year: 2025, month: 6, day: 1) // 예상되는 날짜
        guard let expectedDate = Calendar.current.date(from: expectedDateComponents) else {
            return XCTFail("Failed to create expected date from components")
        }
        
        XCTAssertEqual(calendarVM.getCalendarMonth(), expectedDate, "The month should be changed to the next month")
    }
}
