//
//  MiniCalendarBodyView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

struct MiniCalendarBodyView: View {
    let calendarVM: MiniCalendarViewModel
    
    private var daysInCurrentMonth: Int {
        numberOfDays(month: calendarVM.getCalendarMonth())
    }
    private var firstWeekday: Int {
        firstWeekdayOfMonth(month: calendarVM.getCalendarMonth()) - 1
    }
    
    private var daysInPreviousMonth: Int {
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendarVM.getCalendarMonth()) else {
            return numberOfDays(month: calendarVM.getCalendarMonth())
        }
        
        return numberOfDays(month: previousMonth)
    }
    
    var body: some View {
        VStack {
            dateHeaderView()
            
            dateGridView()
        }
    }
}

private extension MiniCalendarBodyView {
    // 해당 월에 총 날짜 수
    func numberOfDays(month: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    // 해당 월의 첫 날짜가 갖는 요일
    func firstWeekdayOfMonth(month: Date) -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
    @ViewBuilder
    func dateHeaderView() -> some View {
        let weekends: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(weekends, id:\.self) { weekend in
                Text(weekend)
                    .foregroundStyle(Color(uiColor: .systemGray3))
            }
        }
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    func dateGridView() -> some View {
        let weekCount = Int(ceil(Double(daysInCurrentMonth + firstWeekday) / 7)) // 해당 달의 행의 갯 수
        let currentMonthDays = daysInCurrentMonth + firstWeekday // 이번 달의 날짜를 구분하기 위한 변수
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 5) {
            ForEach(0 ..< weekCount * 7, id: \.self) { index in
                if index < firstWeekday {
                    let day = daysInPreviousMonth - firstWeekday + index + 1
                    
                    dayView(day: day, month: -1)
                } else if(index < currentMonthDays) { // 이번 달
                    let day = index - firstWeekday + 1
                    
                    dayView(day: day)
                } else {
                    dayView(day: index - currentMonthDays + 1, month: 1)
                }
            }
        }
    }
    
    @ViewBuilder
    func dayView(day: Int, month: Int = 0) -> some View {
        Button {
            calendarVM.changeMonth(value: month)
        } label: {
            VStack(spacing: 5) {
                Text(String(day))
                    .foregroundStyle(month == 0 ? .black : .gray)
            }
        }
    }
}
