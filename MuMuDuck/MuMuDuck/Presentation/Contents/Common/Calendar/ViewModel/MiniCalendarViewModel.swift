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
}
