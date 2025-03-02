//
//  WeeklyCalendarViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/26/25.
//

import SwiftUI

class WeeklyCalendarViewModel {
    // 주간 캘린더에서 보여줄 달력의 제한치 임의로 1년으로 잡아둠
    let weekRange: Int = 52
    
    // 두 날짜 비교 함수
    // first == second -> 0, first > second -> 1, first < second -> 2
    func compareFirstAndSecond(first: Date, second: Date) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        let firstComponents = calendar.dateComponents([.year, .month, .day], from: first)
        let secondComponents = calendar.dateComponents([.year, .month, .day], from: second)
        
        if let firstYear = firstComponents.year, let firstMonth = firstComponents.month, let firstDay = firstComponents.day,
           let secondYear = secondComponents.year, let secondMonth = secondComponents.month, let secondDay = secondComponents.day {
            
            if firstYear != secondYear {
                return firstYear < secondYear ? 2 : 1
            }
            if firstMonth != secondMonth {
                return firstMonth < secondMonth ? 2 : 1
            }
            if firstDay != secondDay {
                return firstDay < secondDay ? 2 : 1
            }
            
            return 0;
        }
        
        return -1 // 잘못된 변수가 전달된 경우로 예외처리 필요
    }
    
    // 선택한 주말을 기준으로 앞으로 1년, 뒤로 1년간의 Date 정보 주 단위로 반환
    func getDaysPerWeek(week: [Date]) -> [[Date]] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        var weeks: [[Date]] = []
        
        for i in -weekRange...weekRange {
            weeks.append(week.map({ date in
                calendar.date(byAdding: .day, value: 7 * i, to: date)!
            }))
            
        }
        
        return weeks
    }
    
    // 선택한 주말을 기준으로 앞으로 1년, 뒤로 1년간의 Date 정보 일 단위로 반환
    func getDays(week: [Date]) -> [Date] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        var weeks: [Date] = []
        
        for i in -weekRange...weekRange {
            weeks = weeks + week.map({ date in
                calendar.date(byAdding: .day, value: 7 * i, to: date)!
            })
        }
        
        return weeks
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func timeToString(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: time)
    }
}
