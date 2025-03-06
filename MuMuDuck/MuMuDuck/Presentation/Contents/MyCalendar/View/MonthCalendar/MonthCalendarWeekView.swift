//
//  WeeklyDayView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/19/25.
//

import SwiftUI

struct MonthCalendarWeekView: View {
    let myCalendarVM: MyCalendarTapViewModel
    let monthCalendarVM: MonthCalendarViewModel
    let weeklyDate: [Date]
   
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
            ForEach(weeklyDate, id:\.self) { date in
                VStack {
                    Text("\(fetchDay(date: date))")
                        .font(.system(size: 14))
                        .foregroundStyle(fetchColor(date: date))
                        .background {
                            // 접힌 달력에서 날짜가 같은 경우에만 표시
                            if (monthCalendarVM.isOutspread == false && isSameDate(date1: date, date2: myCalendarVM.selectedDate)) {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color(uiColor: .accent))
                            }
                        }
                }
                .frame(height: 40)
                .onTapGesture {
                    myCalendarVM.changeMonth(newMonth: date)
                    
                    if monthCalendarVM.isOutspread {
                        if myCalendarVM.selectedWeek.isEmpty {
                            myCalendarVM.changeSelectedWeek(newSelectedWeek: weeklyDate)
                            // 선택한 주가 위로 올라가는 애니메이션을 위해 0.5초의 딜레이 주기
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                myCalendarVM.changeSelectedDate(newSelectedDate: date)
                            }
                        } else {
                            myCalendarVM.changeSelectedDate(newSelectedDate: date)
                        }
                    } else {
                        myCalendarVM.changeSelectedDate(newSelectedDate: date)
                    }
                }
            }
        }
        
    }
}

private extension MonthCalendarWeekView {
    func fetchDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func fetchColor(date: Date) -> Color {
        // 접힌 달력 또는 주력이면서 선택한 날짜와 같은 경우
        if isSameDate(date1: date, date2: myCalendarVM.selectedDate) && (monthCalendarVM.isOutspread == false || myCalendarVM.selectedWeek.isEmpty == false) {
            return .white
        } else if isSameDate(date1: date, date2: Date()) { // 펼친 달력 && 오늘인 경우
            return .accent
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let currentMonthComponents = Calendar.current.dateComponents([.year, .month, .day], from: myCalendarVM.month)
        
        if dateComponents.year == currentMonthComponents.year &&
            dateComponents.month == currentMonthComponents.month { // 달력에 표기되는 달에 해당하는 경우
            return .black
        }
        return .gray // 이전달이나 다음달의 경우
    }
    
    // selectedDate가 optional이기 때문에 nil인 경우 예외처리
    func isSameDate(date1: Date?, date2: Date?) -> Bool {
        guard let first = date1, let second = date2 else {
            return false
        }
        
        let firstComponents = Calendar.current.dateComponents([.year, .month, .day], from: first)
        let secondComponents = Calendar.current.dateComponents([.year, .month, .day], from: second)
        
        if firstComponents.year == secondComponents.year &&
            firstComponents.month == secondComponents.month &&
            firstComponents.day == secondComponents.day {
            return true
        }
        return false
    }
}
