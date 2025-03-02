//
//  WeeklyCalendarViewModelTests.swift
//  MuMuDuckTests
//
//  Created by 강승우 on 3/2/25.
//

import XCTest
@testable import MuMuDuck

final class WeeklyCalendarViewModelTests: XCTestCase {

    func test_whenGivewTwoDates_thenReturnCompareResult() {
        // given
        let weeklyCalendarVM = WeeklyCalendarViewModel()
        let date1 = getDate(year: 2025, month: 2, day: 11)
        let date2 = getDate(year: 2025, month: 2, day: 11)
        let date3 = getDate(year: 2025, month: 3, day: 15)
        let date4 = getDate(year: 2025, month: 2, day: 15)
        
        // when
        let result1 = weeklyCalendarVM.compareFirstAndSecond(first: date1, second: date2)
        let result2 = weeklyCalendarVM.compareFirstAndSecond(first: date1, second: date3)
        let result3 = weeklyCalendarVM.compareFirstAndSecond(first: date1, second: date4)
        let result4 = weeklyCalendarVM.compareFirstAndSecond(first: date3, second: date4)
        
        // then
        XCTAssertEqual(result1, 0) // 두 날짜가 같으므로 0
        XCTAssertEqual(result2, 2) // second의 날짜가 first의 날짜보다 늦으므로 2
        XCTAssertEqual(result3, 2) // second의 날짜가 first의 날짜보다 늦으므로 2
        XCTAssertEqual(result4, 1) // first의 날짜가 second의 날짜보다 늦으므로 1
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
