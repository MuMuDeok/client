//
//  MiniCalendarHeaderView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

// 달력 상단 월, 월 변경 화살표
struct CalendarHeaderView: View {
    @Binding var month: Date
    let isSelectWeek: Bool
    let canChangeMonth: Bool
    
    init(month: Binding<Date>, isSelectWeek: Bool, canChangeMonth: Bool = true) {
        self._month = month
        self.isSelectWeek = isSelectWeek
        self.canChangeMonth = canChangeMonth
    }
    
    var body: some View {
        VStack {
            monthView()
            
            dateHeaderView()
        }
        .padding(.horizontal, 20)
    }
    
    private func dateToMonth(date: Date) -> String {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "yyyy년 M월"
        
        return dateFormmatter.string(from: date)
    }
    
    private func changeMonth(month: Date, value: Int) -> Date {
        let calendar = Calendar.current
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: month) else {
            return Date()
        }
        
        return newMonth
    }
}

private extension CalendarHeaderView {
    @ViewBuilder
    func dateHeaderView() -> some View {
        let weekends: [String] = ["일", "월", "화", "수", "목", "금", "토"]
        
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(weekends, id:\.self) { weekend in
                Text(weekend)
                    .font(.system(size: 14))
                    .foregroundStyle(.black)
            }
        }
    }
    
    @ViewBuilder
    func monthView() -> some View {
        HStack {
            Text(dateToMonth(date: month))
                
            if self.canChangeMonth {
                Image(systemName: "chevron.down")
            }
        }
        .padding(.top, 5)
        .padding(.bottom, 10)
    }
}
