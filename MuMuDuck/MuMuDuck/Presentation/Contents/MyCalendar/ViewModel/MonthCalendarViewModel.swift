//
//  MonthCalendarViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/7/25.
//

import SwiftUI

@Observable
class MonthCalendarViewModel {
    var isChangingMonthAndYear: Bool = false
    var isOutspread: Bool = false
    
    func toggleIsChangingMonthAndYear() {
        self.isChangingMonthAndYear.toggle()
    }
    
    func toggleIsOutspread() {
        self.isOutspread.toggle()
    }
    
    func getChangeMonth(month: Date, value: Int) -> Date {
        let calendar = Calendar.current
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: month) else {
            return Date()
        }
        
        return newMonth
    }
    
    // 해당 월에 총 날짜 수
    func dayNumberOfMonth(month: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    // 해당 월의 첫 날짜가 갖는 요일
    func firstWeekdayOfMonth(month: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    // date2가 date1보다 같거나 뒤에 있는 날인지 확인하는 함수
    func isLateDate(date1: Date, date2: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let result = calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
        
        return result >= 0
    }
    
    func getDayDiff(date1: Date, date2: Date) -> Int {
        // 한국 시간대 설정
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        // 두 날짜를 한국 시간대에 맞춰 날짜만 추출
        let startOfDate1 = calendar.startOfDay(for: date1)
        let startOfDate2 = calendar.startOfDay(for: date2)
        
        // 날짜 차이 계산
        let difference = calendar.dateComponents([.day], from: startOfDate1, to: startOfDate2)
        
        return abs(difference.day ?? 0)
    }
    
    // 해당 주에서 이벤트가 가장 많은 날의 이벤트 갯수
    func getLoopCount(date: [Date], events: [any Event]) -> Int {
        var loopCount = 0
        var weekEventsCount = Array(repeating: 0, count: 7)
        
        events.forEach { event in
            let startDate = isLateDate(date1: event.startDate, date2: date[0]) ? date[0] : event.startDate
            let endDate = isLateDate(date1: date[6], date2: event.endDate) ? date[6] : event.endDate
            
            let index = getDayDiff(date1: startDate, date2: date[0])
            let continueDays = getDayDiff(date1: startDate, date2: endDate)
            
            for i in index...index + continueDays {
                weekEventsCount[i] += 1
            }
        }
        
        for i in 0...6 {
            loopCount = max(loopCount, weekEventsCount[i])
        }
        
        return loopCount
    }
    
    // 특정 월에 달력에 보이는 모든 날의 배열 -> 배열 당 7개씩 하나의 주에 해당하는 정보를 가짐
    func getCurrentMonthAllDate(month: Date) -> [[Date]] {
        let calendar = Calendar.current
        let daysInCurrentMonth = dayNumberOfMonth(month: month) // 해당 월의 첫 날짜가 갖는 요일
        let firstWeekday = firstWeekdayOfMonth(month: month)
        
        let currentMonthDays = daysInCurrentMonth + firstWeekday // 이번 달의 날짜를 구분하기 위한 변수
        let weekCount = Int(ceil(Double(currentMonthDays) / 7))
        
        var days: [[Date]] = []
        
        var currentMonthComponent = calendar.dateComponents([.year, .month], from: month)
        var previousMonthComponent = calendar.dateComponents([.year, .month], from: getChangeMonth(month: month, value: -1))
        var nextMonthComponent = calendar.dateComponents([.year, .month], from: getChangeMonth(month: month, value: 1))
        
        var dayArr: [Date] = []
        
        for i in 1...weekCount * 7 {
            if i < firstWeekday { // 저번 달
                let day = dayNumberOfMonth(month: getChangeMonth(month: month, value: -1)) - firstWeekday + i
                previousMonthComponent.day = day
                
                dayArr.append(calendar.date(from: previousMonthComponent)!)
            } else if(i < currentMonthDays) { // 이번 달
                let day = i - firstWeekday
                currentMonthComponent.day = day
                
                dayArr.append(calendar.date(from: currentMonthComponent)!)
            } else { // 다음 달
                let day = i - currentMonthDays
                nextMonthComponent.day = day
                
                dayArr.append(calendar.date(from: nextMonthComponent)!)
            }
            
            if i % 7 == 0 {
                days.append(dayArr)
                dayArr.removeAll()
            }
        }
        
        return days
    }
    
    // 1주일의 날짜 정보를 받아서 새로운 모델, 뷰를 그려야하는 배열 정보, 1주일간 이벤트가 가장 많은 날의 이벤트 수(해당 주의 이벤트 행의 수)를 반환
    func getWeekData(date: [Date], events: [any Event]) -> ([CalendarDayEvents], [[Bool]], Int) {
        let loopCount: Int = getLoopCount(date: date, events: events)
        
        let emptyArray: [(any Event)?] = Array(repeating: nil, count: loopCount)
        var skipArray: [[Bool]] = Array(repeating: Array(repeating: false, count: loopCount), count: 7)
        
        var dayInfoes: [CalendarDayEvents] = date.map { day in
            CalendarDayEvents(date: day, events: emptyArray)
        }
        for dateIndex in 0...6 {
            let dateEvents: [any Event] = events.filter { event in
                let startDate = isLateDate(date1: event.startDate, date2: date[0]) ? date[0] : event.startDate
                
                return getDayDiff(date1: startDate, date2: date[dateIndex]) == 0
            }
            
            var eventIndex = 0
            
            for loopIndex in 0..<loopCount {
                if skipArray[dateIndex][loopIndex] == false && eventIndex < dateEvents.count {
                    dayInfoes[dateIndex].events[loopIndex] = dateEvents[eventIndex]
                    
                    let startDate = isLateDate(date1: dateEvents[eventIndex].startDate, date2: date[0]) ? date[0] : dateEvents[eventIndex].startDate
                    let endDate = isLateDate(date1: date[6], date2: dateEvents[eventIndex].endDate) ? date[6] : dateEvents[eventIndex].endDate
                    
                    let continueDays = getDayDiff(date1: startDate, date2: endDate)
                    
                    if continueDays >= 1 {
                        for i in 1...continueDays {
                            skipArray[dateIndex+i][loopIndex] = true
                        }
                    }
                    eventIndex += 1
                }
            }
        }
        
        return (dayInfoes, skipArray, loopCount)
    }
    
    // 이벤트와 주말의 처음과 끝을 비교한 후 변환된 값을 기준으로 시작 날짜와 종료 날짜의 차이를 계산해주는 함수
    func getContinueDay(eventStartDate: Date, eventEndDate: Date, weekStartDate: Date, weekEndDate: Date) -> Int {
        let startDate = isLateDate(date1: eventStartDate, date2: weekStartDate) ? weekStartDate : eventStartDate
        let endDate = isLateDate(date1: weekEndDate, date2: eventEndDate) ? weekEndDate : eventEndDate
        
        return getDayDiff(date1: startDate, date2: endDate)
    }
    
    // 인자로 넘긴 date 변수와 현재 달력이 보여주는 월이 같은지 확인하는 함수
    func isSameMonth(month: Date, date: Date) -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        let monthComponents = Calendar.current.dateComponents([.year, .month], from: month)
        
        if dateComponents.year == monthComponents.year && dateComponents.month == monthComponents.month {
            return true
        }
        return false
    }
}
