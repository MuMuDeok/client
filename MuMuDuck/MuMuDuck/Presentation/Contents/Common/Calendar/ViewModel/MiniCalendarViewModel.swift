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
    private var selectedDay: Date
    
    init(calendarMonth: Date = Date(), selectedDay: Date = Date()) {
        self.calendarMonth = calendarMonth
        self.selectedDay = selectedDay
    }
    
    func getCalendarMonth() -> Date {
        return calendarMonth
    }
    
    func getSelectedDay() -> Date {
        return selectedDay
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
