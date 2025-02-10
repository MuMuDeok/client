//
//  MiniCalendarViewModelTests.swift
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
        
        let calendarVM = MiniCalendarViewModel()
        var month = calendarDate
        
        // when
        let calendarMonth = calendarVM.changeMonth(month: calendarDate, value: 1) // 다음 달로 변경
        
        // then
        let expectedDateComponents = DateComponents(year: 2025, month: 6, day: 1) // 예상되는 날짜
        guard let expectedDate = Calendar.current.date(from: expectedDateComponents) else {
            return XCTFail("Failed to create expected date from components")
        }
        
        XCTAssertEqual(calendarMonth, expectedDate, "The month should be changed to the next month")
    }
    
    
    func test_whenGetFeburaryTotalDays_thenReturn28() {
        // given
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 2    // 테스트를 위해 2월로 설정
        dateComponents.day = 1
        
        guard let calendarDate = Calendar.current.date(from: dateComponents) else {
            return XCTFail("Failed to create date from components")
        }
        
        let calendarVM = MiniCalendarViewModel()
        
        // when
        let days = calendarVM.numberOfDays(month: calendarDate)
        
        // then
        XCTAssertEqual(days, 28, "Return value must be 28")
    }
    
    func test_whenClickNextMonth15_thenCalendarMonthAndSelectedDateMonthWillChangeTo3AndSelectedDateWill15() {
        // given
        let calendar = Calendar.current
        var calendarDateComponents = DateComponents()
        calendarDateComponents.year = 2025
        calendarDateComponents.month = 2    // 테스트를 위해 2월로 설정
        calendarDateComponents.day = 1
        
        guard let calendarDate = calendar.date(from: calendarDateComponents) else {
            return XCTFail("Failed to create date from components")
        }
        let calendarVM = MiniCalendarViewModel()
        var selectedDate = calendarDate
        var month = calendarDate
        
        // when
        calendarDateComponents.month = 3
        
        guard let newCalendarDate = calendar.date(from: calendarDateComponents) else {
            return XCTFail("Failed to create date from components")
        }
        selectedDate = calendarVM.clickDate(month: newCalendarDate, day: 15)
        month = selectedDate
        
        // then
        guard let calendarMonth = calendar.dateComponents([.month], from: month).month else {
            return XCTFail("Failed to get month from components")
        }
        
        let selectedDateComponents = calendar.dateComponents([.month, .day], from: selectedDate)
        guard let selectedMonth = selectedDateComponents.month, let selectedDay = selectedDateComponents.day else {
            return XCTFail("Failed to get month and day from components")
        }
        
        XCTAssertEqual(calendarMonth, 3)
        XCTAssertEqual(selectedMonth, 3)
        XCTAssertEqual(selectedDay, 15)
    }
}
