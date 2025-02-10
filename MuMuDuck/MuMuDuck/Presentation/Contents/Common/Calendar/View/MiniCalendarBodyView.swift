//
//  MiniCalendarBodyView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

struct MiniCalendarBodyView: View {
    let calendarVM: MiniCalendarViewModel
    @Binding var month: Date
    @Binding var selectedDate: Date
    
    var body: some View {
        VStack {
            // 요일을 보여주는 뷰
            dateHeaderView()
            
            // 달력의 실제 날짜들을 보여주는 뷰
            dateGridView()
        }
    }
    
    private func createDateWithDayAndMonthValue(month: Date, value: Int, day: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: calendarVM.changeMonth(month: month, value: value))
        dateComponents.day = day
        
        let date = calendar.date(from: dateComponents) ?? Date()
        return date
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
        let firstWeekDayOfMonth = calendarVM.firstWeekdayOfMonth(month: month)
        let currentMonthDays = calendarVM.numberOfDays(month: month)
        let currentMonthEndDays = firstWeekDayOfMonth + currentMonthDays // 첫째 주 일요일부터 시작했을 때 이번 달 마지막 날의 인덱스
        let weekCount: Int = Int(ceil(Double(firstWeekDayOfMonth + currentMonthDays) / 7)) // 해당 달의 행의 갯 수
        let previousMonth = calendarVM.changeMonth(month: month, value: -1)
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
            ForEach(0 ..< weekCount * 7, id: \.self) { index in
                if index < firstWeekDayOfMonth {
                    let previousMonthDays: Int = calendarVM.numberOfDays(month: previousMonth)
                    let day: Int = previousMonthDays - firstWeekDayOfMonth + index + 1
                    
                    dayView(day: day, changeMonthValue: -1)
                } else if(index < currentMonthEndDays) { // 이번 달
                    let day = index - firstWeekDayOfMonth + 1
                    
                    dayView(day: day)
                } else {
                    dayView(day: index - currentMonthEndDays + 1, changeMonthValue: 1)
                }
            }
        }
    }
    
    @ViewBuilder
    func dayView(day: Int, changeMonthValue: Int = 0) -> some View {
        let newMonth = calendarVM.changeMonth(month: month, value: changeMonthValue)
        
        VStack(spacing: 10) {
            Button {
                self.selectedDate = calendarVM.clickDate(month: newMonth, day: day)
            } label: {
                VStack(spacing: 5) {
                    Text(String(day))
                        .foregroundStyle(changeMonthValue == 0 ? .black : .gray)
                        .font(calendarVM.isSelectedDay(month: newMonth, day: day, selectedDate: selectedDate) ?
                            .system(size: 14, weight: .bold) : .system(size: 14))
                }
            }
            
            HStack(alignment: .center, spacing: 2) {
                let maxPointCount: Int = 3
                let filteredEvents = calendarVM.retrieveDateEventUsecase.execute(date: createDateWithDayAndMonthValue(month: month, value: changeMonthValue, day: day))
                let pointCount: Int = min(filteredEvents.count, maxPointCount)
                
                if pointCount == 0 {
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundStyle(.clear)
                } else {
                    ForEach(0..<pointCount) { index in
                        Circle()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(changeMonthValue == 0 ? .black : .gray)
                    }
                }
            }
        }
    }
}
