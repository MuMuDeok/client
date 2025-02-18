//
//  MiniCalendarView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

struct MiniCalendarView: View {
    let calendarVM: MiniCalendarViewModel = MiniCalendarViewModel()
    @State var isGestured: Bool = false
    @Binding var month: Date
    @Binding var selectedDate: Date
    
    var body: some View {
        dateGridView()
            .gesture(dragGesture)
    }
}

// 메서드
private extension MiniCalendarView {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.location.x - gesture.startLocation.x > 100 && isGestured == false {
                    month = calendarVM.changeMonth(month: month, value: -1)
                    self.isGestured = true
                } else if gesture.location.x - gesture.startLocation.x < -100 && isGestured == false {
                    month = calendarVM.changeMonth(month: month, value: 1)
                    self.isGestured = true
                }
            }
            .onEnded { _ in
                self.isGestured = false
            }
    }
    
    func createDateWithDayAndMonthValue(month: Date, value: Int, day: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month], from: calendarVM.changeMonth(month: month, value: value))
        dateComponents.day = day
        
        let date = calendar.date(from: dateComponents) ?? Date()
        return date
    }
}

// 뷰
private extension MiniCalendarView {
    @ViewBuilder
    func dayView(day: Int, changeMonthValue: Int = 0) -> some View {
        let newMonth = calendarVM.changeMonth(month: month, value: changeMonthValue)
        
        VStack(spacing: 18) {
            Button {
                self.month = newMonth
                self.selectedDate = calendarVM.clickDate(month: newMonth, day: day)
            } label: {
                if calendarVM.isSelectedDay(month: newMonth, day: day, selectedDate: selectedDate) { // 선택한 날짜인지
                    Text(String(day))
                        .foregroundStyle(.white)
                        .font(.system(size: 14, weight: .bold))
                        .background {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(changeMonthValue == 0 ? .accent : Color(uiColor: .systemGray3))
                        }
                    
                } else if calendarVM.isSelectedDay(month: newMonth, day: day, selectedDate: Date()) { // 오늘 날짜
                    Text(String(day))
                        .foregroundStyle(.accent)
                        .font(.system(size: 14, weight: .bold))
                        .background {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.clear)
                        }
                    
                } else {
                    Text(String(day))
                        .foregroundStyle(changeMonthValue == 0 ? .black : .gray)
                        .font(.system(size: 14))
                        .background {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.clear)
                        }
                }
            }
            
            HStack(alignment: .center, spacing: 2) {
                let maxPointCount: Int = 3
                let filteredEvents = calendarVM.retrieveDateEventUsecase.execute(date: createDateWithDayAndMonthValue(month: month, value: changeMonthValue, day: day))
                let pointCount: Int = min(filteredEvents.count, maxPointCount)
                
                if pointCount == 0 {
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundStyle(.clear)
                } else {
                    ForEach(0..<pointCount, id:\.self) { index in
                        Circle()
                            .frame(width: 4, height: 4)
                            .foregroundStyle(changeMonthValue == 0 ? .accent.opacity(1 - Double(index) * 0.3) : .gray.opacity(1 - Double(index) * 0.3))
                    }
                }
            }
        }
        .frame(height: 56)
    }
    
    @ViewBuilder
    func dateGridView() -> some View {
        let firstWeekDayOfMonth = calendarVM.firstWeekdayOfMonth(month: month)
        let currentMonthDays = calendarVM.numberOfDays(month: month)
        let currentMonthEndDays = firstWeekDayOfMonth + currentMonthDays // 첫째 주 일요일부터 시작했을 때 이번 달 마지막 날의 인덱스
        let weekCount: Int = Int(ceil(Double(firstWeekDayOfMonth + currentMonthDays) / 7)) // 해당 달의 행의 갯 수
        let previousMonth = calendarVM.changeMonth(month: month, value: -1)
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
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
        .padding(.horizontal, 20)
    }
}
