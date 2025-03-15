//
//  MyCalendarTapView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import SwiftUI

struct MyCalendarTapView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State var myCalendarVM: MyCalendarTapViewModel = MyCalendarTapViewModel()
    @State var monthCalendarVM: MonthCalendarViewModel = MonthCalendarViewModel()
    @State var weeklyCalendarVM: WeeklyCalendarViewModel = WeeklyCalendarViewModel()
    @State var isCreatingEvent: Bool = false
    
    var body: some View {
        VStack {
            // 주간 캘린더
            if myCalendarVM.selectedWeek.isEmpty == false && myCalendarVM.selectedDate != nil {
                WeeklyCalendarView(myCalendarVM: myCalendarVM, weeklyCalendarVM: weeklyCalendarVM, isCreatingEvent: $isCreatingEvent)
            } else { // 월간 캘린더
                MonthCalendarView(myCalendarVM: myCalendarVM, monthCalendarVM: monthCalendarVM, isCreatingEvent: $isCreatingEvent)
            }
        }
        .sheet(isPresented: $isCreatingEvent, content: {
            CreatePersonalEventView(myCalendarVM: myCalendarVM, selectedDate: myCalendarVM.selectedDate ?? Date())
        })
    }
}
