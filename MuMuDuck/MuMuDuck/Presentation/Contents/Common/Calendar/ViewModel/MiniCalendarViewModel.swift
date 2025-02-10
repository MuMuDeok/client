//
//  MiniCalendarViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

@Observable
class MiniCalendarViewModel {
    let retrieveDateEventUsecase: RetrieveDateEventUsecase
    
    init() {
        self.retrieveDateEventUsecase = RetrieveDateEventUsecase()
    }
    
    func isSelectedDay(month: Date, day: Int, selectedDate: Date) -> Bool {
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
    
    func clickDate(month: Date, day: Int) -> Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: month)
        dateComponents.day = day
        
        guard let newDate = Calendar.current.date(from: dateComponents) else {
            return month
        }
        
        return newDate
    }
    
    func changeMonth(month: Date, value: Int) -> Date {
        let calendar = Calendar.current
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: month) else {
            return Date()
        }
        
        return newMonth
    }
    
    // 해당 월의 총 날짜 수
    func numberOfDays(month: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    // 달력이 보여주는 월의 첫 날짜가 갖는 요일
    func firstWeekdayOfMonth(month: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
    }
}
