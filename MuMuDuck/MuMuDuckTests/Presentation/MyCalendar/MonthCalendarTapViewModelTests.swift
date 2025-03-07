//
//  MyCalendarViewModelTests.swift
//  MuMuDuckTests
//
//  Created by 강승우 on 2/12/25.
//

import XCTest
@testable import MuMuDuck

final class MonthCalendarTapViewModelTests: XCTestCase {
    func test_whenTwoDateMonthSame_thenReturnTrue() {
        // given
        let monthCalendarVM = MonthCalendarViewModel()
        let month = getDate(year: 2025, month: 2, day: 15)
        let date1 = getDate(year: 2025, month: 2, day: 11)
        let date2 = getDate(year: 2025, month: 3, day: 15)
        
        // when
        let result1 = monthCalendarVM.isSameMonth(month: month, date: date1)
        let result2 = monthCalendarVM.isSameMonth(month: month, date: date2)
        
        // then
        XCTAssertEqual(result1, true)
        XCTAssertEqual(result2, false)
    }
    
    func test_whenGiveTwoDate_thenReturnDifferenceOfDayTwoDate() {
        // given
        let monthCalendarVM = MonthCalendarViewModel()
        let date1 = getDate(year: 2025, month: 2, day: 11)
        let date2 = getDate(year: 2025, month: 2, day: 15)
        let date3 = getDate(year: 2025, month: 2, day: 6)
        
        // when
        let result1 = monthCalendarVM.getDayDiff(date1: date1, date2: date2)
        let result2 = monthCalendarVM.getDayDiff(date1: date1, date2: date3)
        
        // then
        XCTAssertEqual(result1, 4)
        XCTAssertEqual(result2, 5)
    }

    func test_whenGiveWeekDates_thenReturnEventCountOfDayWhichHaveMaximumEvents() {
        // given
        let monthCalendarVM = MonthCalendarViewModel()
        var dates: [Date] = []
        for i in 0...6 {
            let date = getDate(year: 2025, month: 2, day: 9 + i)
            dates.append(date)
        }
        
        // when
        let maximumEventCount = monthCalendarVM.getLoopCount(date: dates, events: [
                PersonalEvent(title: "테스트A", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 13), endDate: getDate(year: 2025, month: 02, day: 19), isAlert: true),
                PersonalEvent(title: "테스트B", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 6), endDate: getDate(year: 2025, month: 02, day: 19), isAlert: true),
                PersonalEvent(title: "테스트C", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 12), endDate: getDate(year: 2025, month: 02, day: 14), isAlert: true),
                PersonalEvent(title: "테스트D", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 13), endDate: getDate(year: 2025, month: 02, day: 13), isAlert: false),
                PersonalEvent(title: "테스트E", isAllDay: true, startDate: getDate(year: 2025, month: 02, day: 15), endDate: getDate(year: 2025, month: 3, day: 1), isAlert: false),
        ])
        
        // then
        XCTAssertEqual(maximumEventCount, 4)
    }
    
    func test_whenGiveEventDateAndWeekDate_thenReturnConvertedDateDuration() {
        // given
        let monthCalendarVM = MonthCalendarViewModel()
        let eventStartDate = getDate(year: 2025, month: 2, day: 13)
        let eventEndDate = getDate(year: 2025, month: 2, day: 18)
        let weekStartDate = getDate(year: 2025, month: 2, day: 16)
        let weekEndDate = getDate(year: 2025, month: 2, day: 22)
        
        // when
        let dayCount = monthCalendarVM.getContinueDay(eventStartDate: eventStartDate, eventEndDate: eventEndDate, weekStartDate: weekStartDate, weekEndDate: weekEndDate)
        
        // then
        XCTAssertEqual(dayCount, 2)
    }
    
    func test_whenGiveTwoDate_thenReturnTrueIfSecondDateLateThanFirstDate() {
        // given
        let monthCalendarVM = MonthCalendarViewModel()
        
        let firstDate1 = getDate(year: 2025, month: 2, day: 13)
        let secondDate1 = getDate(year: 2025, month: 2, day: 18)
        let firstDate2 = getDate(year: 2025, month: 3, day: 2)
        let secondDate2 = getDate(year: 2025, month: 2, day: 18)
        
        // when
        let result1 = monthCalendarVM.isLateDate(date1: firstDate1, date2: secondDate1)
        let result2 = monthCalendarVM.isLateDate(date1: firstDate2, date2: secondDate2)
        
        // then
        XCTAssertEqual(result1, true)
        XCTAssertEqual(result2, false)
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
