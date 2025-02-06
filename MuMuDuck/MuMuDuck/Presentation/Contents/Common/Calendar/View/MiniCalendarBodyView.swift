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
        let currentMonthDays = daysInCurrentMonth + firstWeekday // 이번 달의 날짜를 구분하기 위한 변수
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 5) {
            ForEach(0 ..< currentMonthDays, id: \.self) { index in
                if index < firstWeekday {
                    Text("")
                    
                } else { // 이번 달
                    let day = index - firstWeekday + 1
                    
                    dayView(day: day)
                }
            }
        }
    }
    
    @ViewBuilder
    func dayView(day: Int) -> some View {
        VStack(spacing: 5) {
            Text(String(day))
                .foregroundStyle(.black)
        }
    }
}
