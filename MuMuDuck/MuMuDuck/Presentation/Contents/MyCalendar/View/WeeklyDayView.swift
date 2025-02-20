//
//  WeeklyDayView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/19/25.
//

import SwiftUI

struct WeeklyDayView: View {
    @Binding var month: Date
    @Binding var selectedDate: Date
    @Binding var isOutspread: Bool
    let weeklyDate: [Date]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
            ForEach(weeklyDate, id:\.self) { date in
                VStack {
                    Text("\(fetchDay(date: date))")
                        .font(.system(size: 14))
                        .foregroundStyle(fetchColor(date: date))
                        .background {
                            if isOutspread == false && isSameDate(date1: selectedDate, date2: date) {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundStyle(Color(uiColor: .accent))
                            }
                        }
                }
                .frame(height: 40)
                .onTapGesture {
                    self.month = date
                    self.selectedDate = date
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

private extension WeeklyDayView {
    func fetchDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    func fetchColor(date: Date) -> Color {
        if isSameDate(date1: date, date2: selectedDate) && self.isOutspread == false{ // 선택한 날짜와 같은 경우
            return .white
        } else if isSameDate(date1: date, date2: Date()) { // 오늘 날짜와 같은 경우
            return .accent
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let currentMonthComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.month)
        
        if dateComponents.year == currentMonthComponents.year &&
            dateComponents.month == currentMonthComponents.month { // 달력에 표기되는 달에 해당하는 경우
            return .black
        }
        return .gray // 이전달이나 다음달의 경우
    }
    
    func isSameDate(date1: Date, date2: Date) -> Bool {
        let dateComponents1 = Calendar.current.dateComponents([.year, .month, .day], from: date1)
        let dateComponents2 = Calendar.current.dateComponents([.year, .month, .day], from: date2)
        
        if dateComponents1.year == dateComponents2.year &&
            dateComponents1.month == dateComponents2.month &&
            dateComponents1.day == dateComponents2.day {
            return true
        }
        return false
    }
}
