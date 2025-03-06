//
//  MiniCalendarWeeklyEventView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/19/25.
//

import SwiftUI

struct MiniCalendarWeeklyEventView: View {
    let myCalendarVM: MyCalendarTapViewModel
    let weeklyDate: [Date]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
            ForEach(weeklyDate, id: \.self) { date in
                HStack(alignment: .center, spacing: 2) {
                    let maxPointCount: Int = 3
                    let filteredEvents = myCalendarVM.getDayEvents(date: date)
                    let pointCount: Int = min(filteredEvents.count, maxPointCount)
                    
                    if pointCount == 0 {
                        Circle()
                            .frame(width: 4, height: 4)
                            .foregroundStyle(.clear)
                    } else {
                        ForEach(0..<pointCount, id:\.self) { index in
                            Circle()
                                .frame(width: 4, height: 4)
                                .foregroundStyle(fetchColor(date: date, index: index))
                        }
                    }
                }
                .onTapGesture {
                    myCalendarVM.changeMonth(newMonth: date)
                    myCalendarVM.changeSelectedDate(newSelectedDate: date)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

private extension MiniCalendarWeeklyEventView {
    func fetchColor(date: Date, index: Int) -> Color {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let currentMonthComponents = Calendar.current.dateComponents([.year, .month, .day], from: myCalendarVM.month)
        
        if dateComponents.year == currentMonthComponents.year &&
            dateComponents.month == currentMonthComponents.month { // 달력에 표기되는 달에 해당하는 경우
            
            return .accent.opacity(1 - Double(index) * 0.3)
        } else { // 이전달이나 다음달의 경우
            return .gray.opacity(1 - Double(index) * 0.3)
        }
    }
}
