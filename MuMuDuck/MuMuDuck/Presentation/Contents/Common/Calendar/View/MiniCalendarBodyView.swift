//
//  MiniCalendarBodyView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

struct MiniCalendarBodyView: View {
    let calendarVM: MiniCalendarViewModel
    
    var body: some View {
        VStack {
            // 요일을 보여주는 뷰
            dateHeaderView()
            
            // 달력의 실제 날짜들을 보여주는 뷰
            dateGridView()
        }
    }
}

private extension MiniCalendarBodyView {
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
        let firstWeekDayOfMonth = calendarVM.firstWeekdayOfMonth()
        let currentMonthDays = calendarVM.numberOfDays(month: calendarVM.getCalendarMonth())
        let currentMonthEndDays = firstWeekDayOfMonth + currentMonthDays // 첫째 주 일요일부터 시작했을 때 이번 달 마지막 날의 인덱스
        let weekCount = Int(ceil(Double(firstWeekDayOfMonth + currentMonthDays) / 7)) // 해당 달의 행의 갯 수
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 5) {
            ForEach(0 ..< weekCount * 7, id: \.self) { index in
                if index < firstWeekDayOfMonth {
                    let previousMonthDays: Int = calendarVM.numberOfDays(month: calendarVM.getChangedMonth(value: -1))
                    let day = previousMonthDays - firstWeekDayOfMonth + index + 1
                    
                    dayView(day: day, month: -1)
                } else if(index < currentMonthEndDays) { // 이번 달
                    let day = index - firstWeekDayOfMonth + 1
                    
                    dayView(day: day)
                } else {
                    dayView(day: index - currentMonthEndDays + 1, month: 1)
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
