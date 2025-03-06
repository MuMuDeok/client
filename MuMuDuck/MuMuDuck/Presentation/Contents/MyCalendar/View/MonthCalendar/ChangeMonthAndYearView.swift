//
//  ChangeMonthAndYearView.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/5/25.
//

import SwiftUI

struct ChangeMonthAndYearView: View {
    let myCalendarVM: MyCalendarTapViewModel
    let monthCalendarVM: MonthCalendarViewModel
    let monthArray: [[Int]] = [[1,2,3,4], [5,6,7,8], [9,10,11,12]]
    
    var body: some View {
        VStack(spacing: 16) {
            yearSelectView()
            
            monthSelectView()
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(.white)
        }
    }
}

private extension ChangeMonthAndYearView {
    @ViewBuilder
    func yearSelectView() -> some View {
        HStack {
            Button {
                let newMonth = getChangedYearDate(addValue: -1)
                myCalendarVM.changeMonth(newMonth: newMonth)
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Text(getYearFromDate(date: myCalendarVM.month))
            
            Button {
                let newMonth = getChangedYearDate(addValue: 1)
                myCalendarVM.changeMonth(newMonth: newMonth)
            } label: {
                Image(systemName: "arrow.right")
            }
        }
        .font(.system(size: 20))
        .padding(.vertical, 6)
    }
    
    @ViewBuilder
    func monthSelectView() -> some View {
        VStack(spacing: 8) {
            ForEach(monthArray, id:\.self) { array in
                HStack(spacing: 8) {
                    ForEach(array, id:\.self) { number in
                        monthView(number: number)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func monthView(number: Int) -> some View {
        let isSameMonth: Bool = String(number) == getMonthFromDate(date: myCalendarVM.month)
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 48, height: 44)
                .foregroundStyle(isSameMonth ? .accent : Color(uiColor: .systemGray5))
            
            Text("\(number)월")
                .foregroundStyle(isSameMonth ? .white : Color(uiColor: .systemGray2))
        }
        .onTapGesture {
            let newMonth = getChangedMonthDate(newMonth: number)
            myCalendarVM.changeMonth(newMonth: newMonth)
            
            monthCalendarVM.toggleIsChangingMonthAndYear()
        }
    }
    
    func getYearFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        return formatter.string(from: date)
    }
    
    func getMonthFromDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        
        return formatter.string(from: date)
    }
    
    func getChangedYearDate(addValue: Int) -> Date {
        let previousMonth = myCalendarVM.month
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: previousMonth)
        
        guard let year = dateComponents.year else { return previousMonth}
        dateComponents.year = year + addValue
        
        guard let newDate = calendar.date(from: dateComponents) else { return previousMonth}
        return newDate
    }
    
    func getChangedMonthDate(newMonth: Int) -> Date {
        let previousMonth = myCalendarVM.month
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: previousMonth)
        dateComponents.month = newMonth
        
        guard let newDate = calendar.date(from: dateComponents) else { return previousMonth}
        return newDate
    }
}
