//
//  SelectedWeekEventView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/25/25.
//

import SwiftUI

struct WeeklyCalendarView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let myCalendarVM: MyCalendarTapViewModel
    let weeklyCalendarVM: WeeklyCalendarViewModel
    @Binding var month: Date
    @Binding var selectedDate: Date?
    @Binding var selectedWeek: [Date]
    @Binding var isChangingMonthAndYear: Bool
    @State var selection: Int
    @State var scrollID: Date?
    let weeks: [[Date]]
    @State var weeksToShow: [Date]
    @State var isChangeDayByScroll: Bool = false
    @State var isChangeSelectionScroll: Bool = false
    @State var isChangeScrollByDay: Bool = false
    
    init(myCalendarVM: MyCalendarTapViewModel, month: Binding<Date>, isChangingMonthAndYear: Binding<Bool>, selectedDate: Binding<Date?>, selectedWeek: Binding<[Date]>) {
        self.myCalendarVM = myCalendarVM
        self.weeklyCalendarVM = WeeklyCalendarViewModel()
        self._month = month
        self._isChangingMonthAndYear = isChangingMonthAndYear
        self._selectedWeek = selectedWeek
        self.weeks = weeklyCalendarVM.getDaysPerWeek(week: selectedWeek.wrappedValue)
        self.weeksToShow = weeklyCalendarVM.getDays(week: selectedWeek.wrappedValue)
        self.selection = 52 // 선택한 날짜가 포함된 주의 index
        self._selectedDate = selectedDate
    }
    
    var body: some View {
        VStack {
            CalendarHeaderView(month: $month, isChangingMonthAndYear: $isChangingMonthAndYear, isSelectWeek: true, canChangeMonth: false)
            
            TabView(selection: $selection) {
                ForEach(weeks.indices, id:\.self) { index in
                    WeeklyDayView(month: $month, selectedDate: $selectedDate, selectedWeek: $selectedWeek, isOutspread: true, weeklyDate: weeks[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 40)
            .padding(.horizontal, 20)
            
            Rectangle()
                .fill(.white)
                .frame(height: 3)
                .shadow(color: Color(uiColor: .systemGray3), radius: 2, y: 5)
            
            ScrollView {
                LazyVStack {
                    ForEach(weeksToShow, id:\.self) { date in
                        dayView(date: date)
                    }
                }
                .scrollTargetLayout()
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .scrollIndicators(.hidden)
            .scrollPosition(id:$scrollID, anchor: .top)
        }
        .onAppear {
            guard let selectedDate = self.selectedDate else { return }
            
            scrollID = selectedDate
        }
        .onChange(of: self.selectedDate) {
            if isChangeDayByScroll {
                isChangeDayByScroll = false
            } else {
                isChangeScrollByDay = true
                
                withAnimation {
                    scrollID = self.selectedDate
                }
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            guard let selectDate = self.selectedDate else { return }
            
            if isChangeSelectionScroll {
                isChangeSelectionScroll = false
            } else {
                let changeValue = newValue - oldValue
                
                self.selectedDate = Calendar.current.date(byAdding: .day, value: 7 * changeValue, to: selectDate)
                self.month = self.selectedDate!
            }
        }
        .onChange(of: scrollID) {
            if isChangeScrollByDay {
                isChangeScrollByDay = false
            } else {
                if let date = scrollID, date != self.selectedDate {
                    isChangeDayByScroll = true
                    self.selectedDate = date
                    self.month = date
                    
                    // scroll 포지션이 가리키는 날짜가 현재 보여주는 주의 첫 번째 날보다 빠른 날인 경우
                    if weeklyCalendarVM.compareFirstAndSecond(first: date, second: weeks[selection][0]) == 2 {
                        // 제한을 둔 weeks의 범위를 벗어나는 것을 방지하기 위해
                        if self.selection > 0 {
                            isChangeSelectionScroll = true
                            self.selection = selection - 1
                        }
                    }
                    // scroll 포지션이 가리키는 날짜가 현재 보여주는 주의 마지막 날보다 늦은 날인 경우
                    else if weeklyCalendarVM.compareFirstAndSecond(first: date, second: weeks[selection][6]) == 1 {
                        // 제한을 둔 weeks의 범위를 벗어나는 것을 방지하기 위해
                        if self.selection < weeks.count - 1 {
                            isChangeSelectionScroll = true
                            self.selection = selection + 1
                        }
                    }
                }
            }
        }
    }
}

private extension WeeklyCalendarView {
    @ViewBuilder
    func dayView(date: Date) -> some View {
        let events = myCalendarVM.getDayEvents(date: date)
        
        VStack {
            HStack {
                Text(weeklyCalendarVM.dateToString(date: date))
                    .font(.title3)
                
                Spacer()
            }
            
            Divider()
            
            if events.isEmpty {
                Text("일정이 없습니다.")
            } else {
                VStack(spacing: 20) {
                    ForEach(events, id: \.id) { event in
                        eventListItemView(event: event, date: date)
                    }
                }
            }
        }
        .padding(.bottom, 40)
        
    }
    
    @ViewBuilder
    func eventListItemView(event: any Event, date: Date) -> some View {
        Button {
            coordinator.push(.personalEventDetail(event: event as! PersonalEvent))
        } label: {
            HStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width:5, height: 40)
                    .foregroundStyle(.accent)
                
                VStack {
                    Text(event.title)
                        .foregroundStyle(.black)
                    
                    Text(" ")
                }
                
                Spacer()
                
                eventTimeView(event: event, date: date)
                    .font(.system(size: 14))
            }
            .frame(height: 40)
        }
    }
    
    @ViewBuilder
    func eventTimeView(event: any Event, date: Date) -> some View {
        let startDateResult = weeklyCalendarVM.compareFirstAndSecond(first: event.startDate, second: date)
        let endDateResult = weeklyCalendarVM.compareFirstAndSecond(first: event.endDate, second: date)
        
        VStack(alignment: .trailing) {
            if event.isAllDay || (startDateResult == 2 && endDateResult == 1) { // 하루종일인 이벤트 또는 startDate < date < endDate 경우
                Text("하루 종일")
                    .foregroundStyle(.black)
            } else {
                if startDateResult == 0 {
                    Text(weeklyCalendarVM.timeToString(time: event.startDate))
                        .foregroundStyle(.black)
                }
                
                if endDateResult == 0 {
                    if startDateResult != 0 {
                        Text("종료")
                            .foregroundStyle(.black)
                    }
                    
                    Text(weeklyCalendarVM.timeToString(time: event.endDate))
                        .foregroundStyle(.gray)
                } else {
                    Text(" ")
                }
            }
        }
        .frame(height: 50)
    }
}
