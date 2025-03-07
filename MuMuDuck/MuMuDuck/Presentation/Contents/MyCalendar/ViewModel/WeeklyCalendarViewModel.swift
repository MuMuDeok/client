//
//  WeeklyCalendarViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/26/25.
//

import SwiftUI

@Observable
class WeeklyCalendarViewModel {
    // 주간 캘린더에서 보여줄 달력의 제한치 임의로 1년으로 잡아둠
    let weekRange: Int = 76
    var isChangeDayByScroll: Bool = false
    var isChangeSelectionScroll: Bool = false
    var isChangeScrollByDay: Bool = false
    
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
    
    func getSelection(weeks: [[Date]], selectWeek: [Date]) -> Int {
        if compareFirstAndSecond(first: selectWeek[6], second: weeks[0][0]) == 2 { // 주간 캘린더 범위보다 앞에 있는 경우 첫 번째 주의 index 반환
            return 0
        } else if compareFirstAndSecond(first: selectWeek[0], second: weeks.last![6]) == 1 { // 주간 캘린더 범위보다 뒤에 있는 경우 마지막 주의 index 반환
            return weeks.count - 1
        } else {
            for index in 0..<weeks.count {
                if compareFirstAndSecond(first: weeks[index][0], second: selectWeek[0]) == 0 {
                    return index
                }
            }
            
            return weekRange // 오늘이 포함된 주의 index
        }
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
