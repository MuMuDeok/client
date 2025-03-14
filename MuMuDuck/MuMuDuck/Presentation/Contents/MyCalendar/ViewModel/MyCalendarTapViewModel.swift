//
//  MyCalendarTapViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import Foundation

@Observable
class MyCalendarTapViewModel {
    private let retrieveDateEventUsecase: RetrieveDateEventUsecase = RetrieveDateEventUsecase()
    private let retrieveWeekEventUsecase: RetrieveWeekEventUsecase  = RetrieveWeekEventUsecase()
    private let createEventUsecase: CreateEventUsecase = CreateEventUsecase()
    var month: Date = Date()
    var selectedDate: Date? = Date()
    var selectedWeek: [Date] = []
    var isShowWeeklyCalendar: Bool = false
    var weekIncludeToday: [Date] = []
    
    init() {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        guard let newDate = calendar.date(from: todayComponents) else {
            return
        }
        
        let weekday = calendar.component(.weekday, from: newDate)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: newDate) ?? newDate
        self.weekIncludeToday =  (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    func getDayEvents(date: Date) -> [any Event] {
        return retrieveDateEventUsecase.execute(date: date)
    }
    
    func getWeekEvents(date: [Date]) -> [any Event] {
        return retrieveWeekEventUsecase.execute(date: date)
    }
    
    func createPersonalEvent(title: String, isAllDay: Bool, startDate: Date, endDate: Date, alertTime: Int?, memo: String = "") {
        createEventUsecase.execute(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, alertTime: alertTime, memo: memo)
    }
    
    func changeMonth(newMonth: Date) {
        self.month = newMonth
    }
    
    func changeSelectedDate(newSelectedDate: Date?) {
        self.selectedDate = newSelectedDate
    }
    
    func changeSelectedWeek(newSelectedWeek: [Date]) {
        self.selectedWeek = newSelectedWeek
    }
    
    func toggleIsShowWeeklyCalendar() {
        self.isShowWeeklyCalendar.toggle()
    }
    
    func isSelectToday() -> Bool {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ko_KR")
        
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        guard let todayYear = todayComponents.year,
              let todayMonth = todayComponents.month,
              let todayDay = todayComponents.day else {
            return false
        }
        
        let currentCalendarComponents = calendar.dateComponents([.year, .month], from: self.month)
        guard let currentYear = currentCalendarComponents.year,
              let currentMonth = currentCalendarComponents.month else {
            return false
        }
        
        // 현재 보여주는 달 오늘을 포함한 달이 다른 경우
        if todayYear != currentYear || todayMonth != currentMonth {
            return false
        }
        
        guard let selectedDate = self.selectedDate else {
            // selectedDate가 nil인 경우는 펼친 달력인데 위에서 현재 보여주는 달력의 월과 년도를 검사했으므로 true 반환
            return true
        }
        
        let selectedDateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        
        guard let selectedYear = selectedDateComponents.year,
              let selectedMonth = selectedDateComponents.month,
              let selectedDay = selectedDateComponents.day else {
            return false
        }
        
        return todayYear == selectedYear && todayMonth == selectedMonth && todayDay == selectedDay
    }
}
