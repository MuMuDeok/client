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
    
    var body: some View {
        VStack {
            monthAndArrowView()
            
            dateHeaderView()
        }
    }
    
    private func dateToMonth(date: Date) -> String {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "M월"
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
                    .foregroundStyle(Color(uiColor: .systemGray3))
            }
        }
        .padding(.bottom, 5)
    }
    
    @ViewBuilder
    func monthAndArrowView() -> some View {
        HStack {
            Button {
                month = changeMonth(month: month, value: -1)
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Spacer()
            
            Text(dateToMonth(date: month))
            
            Spacer()
            
            Button {
                month = changeMonth(month: month, value: 1)
            } label: {
                Image(systemName: "arrow.right")
            }
        }
        .padding(.horizontal, 20)
    }
}
