//
//  MyCalendarViewModelTests.swift
//  MuMuDuckTests
//
//  Created by 강승우 on 2/12/25.
//

import XCTest
@testable import MuMuDuck

final class MyCalendarTapViewModelTests: XCTestCase {
    func test_whenTwoDateMonthSame_thenReturnTrue() {
        // given
        let myCalenderVM = MyCalendarTapViewModel()
        let month = getDate(year: 2025, month: 2, day: 15)
        let date1 = getDate(year: 2025, month: 2, day: 11)
        let date2 = getDate(year: 2025, month: 3, day: 15)
        
        // when
        let result1 = myCalenderVM.isSameMonth(month: month, date: date1)
        let result2 = myCalenderVM.isSameMonth(month: month, date: date2)
        
        // then
        XCTAssertEqual(result1, true)
        XCTAssertEqual(result2, false)
    }
    
    func test_whenGiveTwoDate_thenReturnDifferenceOfDayTwoDate() {
        // given
        let myCalenderVM = MyCalendarTapViewModel()
        let date1 = getDate(year: 2025, month: 2, day: 11)
        let date2 = getDate(year: 2025, month: 2, day: 15)
        let date3 = getDate(year: 2025, month: 2, day: 6)
        
        // when
        let result1 = myCalenderVM.getDayDiff(date1: date1, date2: date2)
        let result2 = myCalenderVM.getDayDiff(date1: date1, date2: date3)
        
        // then
        XCTAssertEqual(result1, 4)
        XCTAssertEqual(result2, 5)
    }

    func test_whenGiveWeekDates_thenReturnEventCountOfDayWhichHaveMaximumEvents() {
        // given
        let myCalenderVM = MyCalendarTapViewModel()
        var dates: [Date] = []
        for i in 0...6 {
            let date = getDate(year: 2025, month: 2, day: 9 + i)
            dates.append(date)
        }
        
        // when
        let maximumEventCount = myCalenderVM.getLoopCount(date: dates)
        
        // then
        XCTAssertEqual(maximumEventCount, 2)
    }
    
    func test_whenGiveEventDateAndWeekDate_thenReturnConvertedDateDuration() {
        // given
        let myCalendarVM = MyCalendarTapViewModel()
        let eventStartDate = getDate(year: 2025, month: 2, day: 13)
        let eventEndDate = getDate(year: 2025, month: 2, day: 18)
        let weekStartDate = getDate(year: 2025, month: 2, day: 16)
        let weekEndDate = getDate(year: 2025, month: 2, day: 22)
        
        // when
        let dayCount = myCalendarVM.getContinueDay(eventStartDate: eventStartDate, eventEndDate: eventEndDate, weekStartDate: weekStartDate, weekEndDate: weekEndDate)
        
        // then
        XCTAssertEqual(dayCount, 2)
    }
    
    func test_whenGiveTwoDate_thenReturnTrueIfSecondDateLateThanFirstDate() {
        // given
        let myCalendarVM = MyCalendarTapViewModel()
        
        let firstDate1 = getDate(year: 2025, month: 2, day: 13)
        let secondDate1 = getDate(year: 2025, month: 2, day: 18)
        let firstDate2 = getDate(year: 2025, month: 3, day: 2)
        let secondDate2 = getDate(year: 2025, month: 2, day: 18)
        
        // when
        let result1 = myCalendarVM.isLateDate(date1: firstDate1, date2: secondDate1)
        let result2 = myCalendarVM.isLateDate(date1: firstDate2, date2: secondDate2)
        
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
