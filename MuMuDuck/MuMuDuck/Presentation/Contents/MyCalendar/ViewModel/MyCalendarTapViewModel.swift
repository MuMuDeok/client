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
    
    func getDayEvents(date: Date) -> [any Event] {
        return retrieveDateEventUsecase.execute(date: date)
    }
    
    func getWeekEvents(date: [Date]) -> [any Event] {
        return retrieveWeekEventUsecase.execute(date: date)
    }
    
    func createPersonalEvent(title: String, isAllDay: Bool, startDate: Date, endDate: Date, isAlert: Bool, memo: String = "") {
        createEventUsecase.execute(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, isAlert: isAlert, memo: memo)
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
}
