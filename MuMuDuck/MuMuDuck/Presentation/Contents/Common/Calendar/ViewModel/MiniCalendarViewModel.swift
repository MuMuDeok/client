//
//  MiniCalendarViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

@Observable
class MiniCalendarViewModel {
    private var calendarMonth: Date
    private var selectedDate: Date
    let retrieveDateEventUsecase: RetrieveDateEventUsecase
    
    init(calendarMonth: Date = Date(), selectedDay: Date = Date()) {
        self.calendarMonth = calendarMonth
        self.selectedDate = selectedDay
        self.retrieveDateEventUsecase = RetrieveDateEventUsecase()
    }
    
    func getCalendarMonth() -> Date {
        return calendarMonth
    }
    
    func getSelectedDate() -> Date {
        return selectedDate
    }
    
    func isSelectedDay(month: Date, day: Int) -> Bool {
        let selectedDateComponenets = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let compareDateComponenets = Calendar.current.dateComponents([.year, .month], from: month)
        
        guard let selectedYear = selectedDateComponenets.year, let selectedMonth = selectedDateComponenets.month, let selectedDay = selectedDateComponenets.day else {
            return false
        }
        
        guard let compareYear = compareDateComponenets.year, let compareMonth = compareDateComponenets.month else {
            return false
        }
            
        return selectedYear == compareYear && selectedMonth == compareMonth && selectedDay == day
    }
    
    func clickDate(changeMonthValue value: Int, day: Int) {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: getChangedMonth(value: value))
        dateComponents.day = day
        
        guard let newDate = Calendar.current.date(from: dateComponents) else {
            return
        }
        
        self.selectedDate = newDate
        self.changeMonth(value: value) // 다른 달인 경우 달 변경
    }
    
    func changeMonth(value: Int) {
        let calendar = Calendar.current
        if let newMonth = calendar.date(byAdding: .month, value: value, to: calendarMonth) {
            self.calendarMonth = newMonth
        }
    }
    
    func getChangedMonth(value: Int) -> Date {
        let calendar = Calendar.current
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: calendarMonth) else {
            return calendarMonth
        }
        
        return newMonth
    }
    
    // 해당 월의 총 날짜 수
    func numberOfDays(month: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    // 달력이 보여주는 월의 첫 날짜가 갖는 요일
    func firstWeekdayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: calendarMonth)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
    }
}
