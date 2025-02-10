//
//  MiniCalendarHeaderView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

// 달력 상단 월, 월 변경 화살표
struct MiniCalendarHeaderView: View {
    let calendarVM: MiniCalendarViewModel
    @Binding var month: Date
    
    var body: some View {
        HStack {
            Button {
                month = calendarVM.changeMonth(month: month, value: -1)
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Spacer()
            
            Text(dateToMonth(date: month))
            
            Spacer()
            
            Button {
                month = calendarVM.changeMonth(month: month, value: 1)
            } label: {
                Image(systemName: "arrow.right")
            }
        }
        .padding(.horizontal, 20)
    }
    
    private func dateToMonth(date: Date) -> String {
        let dateFormmatter = DateFormatter()
        dateFormmatter.dateFormat = "M월"
        return dateFormmatter.string(from: date)
    }
}
