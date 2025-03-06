//
//  ChangeMonthAndYearView.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/5/25.
//

import SwiftUI

struct ChangeMonthAndYearView: View {
    @Binding var month: Date
    @Binding var isChangingMonthAndYear: Bool
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
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
                self.month = getChangedYearDate(addValue: -1)
            } label: {
                Image(systemName: "arrow.left")
            }
            
            Text(getYearFromDate(date: self.month))
            
            Button {
                self.month = getChangedYearDate(addValue: 1)
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
        let isSameMonth: Bool = String(number) == getMonthFromDate(date: self.month)
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 48, height: 44)
                .foregroundStyle(isSameMonth ? .accent : Color(uiColor: .systemGray5))
            
            Text("\(number)월")
                .foregroundStyle(isSameMonth ? .white : Color(uiColor: .systemGray2))
        }
        .onTapGesture {
            self.month = getChangedMonthDate(newMonth: number)
            self.isChangingMonthAndYear = false
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
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.month)
        
        guard let year = dateComponents.year else { return self.month}
        dateComponents.year = year + addValue
        
        guard let newDate = calendar.date(from: dateComponents) else { return self.month}
        return newDate
    }
    
    func getChangedMonthDate(newMonth: Int) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: self.month)
        dateComponents.month = newMonth
        
        guard let newDate = calendar.date(from: dateComponents) else { return self.month }
        return newDate
    }
}
