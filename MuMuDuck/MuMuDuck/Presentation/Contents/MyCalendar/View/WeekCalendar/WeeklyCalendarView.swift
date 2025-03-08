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
    @Binding var isCreatingEvent: Bool
    
    let weeks: [[Date]]
    @State var selection: Int
    @State var scrollID: Date?
    @State var isChangeDayByScroll: Bool = false
    @State var isChangeSelectionScroll: Bool = false
    @State var isChangeScrollByDay: Bool = false
    @State var isClickTodayButton: Bool = false
    var weeksToShow: [Date] {
        weeks.flatMap{$0}
    }
    
    init(myCalendarVM: MyCalendarTapViewModel, weeklyCalendarVM: WeeklyCalendarViewModel, isCreatingEvent: Binding<Bool>) {
        self.myCalendarVM = myCalendarVM
        self.weeklyCalendarVM = weeklyCalendarVM
        self._isCreatingEvent = isCreatingEvent
        
        let selectWeek = myCalendarVM.selectedWeek
        self.weeks = weeklyCalendarVM.getDaysPerWeek(week: myCalendarVM.weekIncludeToday)
        self.selection = weeklyCalendarVM.getSelection(weeks: weeks, selectWeek: selectWeek)
    }
    
    var body: some View {
        VStack {
            topToolbarView()
            
            Divider()
            
            WeeklyCalendarHeaderView(myCalendarVM: myCalendarVM)
            
            TabView(selection: $selection) {
                ForEach(weeks.indices, id:\.hashValue) { index in
                    WeeklyCalendarWeekView(myCalendarVM: myCalendarVM, weeklyDate: weeks[index])
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
            guard let selectedDate = myCalendarVM.selectedDate else { return }
            isChangeScrollByDay = true
            
            if weeklyCalendarVM.compareFirstAndSecond(first: selectedDate, second: weeksToShow[0]) == 2 {
                scrollID = weeksToShow[0]
            } else if weeklyCalendarVM.compareFirstAndSecond(first: selectedDate, second: weeksToShow.last!) == 1 {
                scrollID = weeksToShow.last!
            } else {
                scrollID = selectedDate
            }
        }
        .onChange(of: myCalendarVM.selectedDate) {
            if isChangeDayByScroll {
                isChangeDayByScroll = false
            } else {
                isChangeScrollByDay = true
                
                DispatchQueue.main.async {
                    withAnimation {
                        scrollID = myCalendarVM.selectedDate
                    }
                }
                
                if isClickTodayButton {
                    isClickTodayButton = false
                }
            }
        }
        .onChange(of: selection) { oldValue, newValue in
            if isClickTodayButton {
                return // 오늘 버튼을 눌렀을 때 selection이 수정되서 발생하는 이벤트를 막기 위해
            }
            
            guard let selectDate = myCalendarVM.selectedDate else { return }
            
            if isChangeSelectionScroll {
                isChangeSelectionScroll = false
            } else {
                let changeValue = newValue - oldValue
                
                let newDate = Calendar.current.date(byAdding: .day, value: 7 * changeValue, to: selectDate)
                myCalendarVM.changeSelectedDate(newSelectedDate: newDate)
                myCalendarVM.changeMonth(newMonth: newDate!)
            }
        }
        .onChange(of: scrollID) {
            if isChangeScrollByDay {
                isChangeScrollByDay = false
            } else {
                if let date = scrollID, date != myCalendarVM.selectedDate {
                    isChangeDayByScroll = true
                    myCalendarVM.changeSelectedDate(newSelectedDate: date)
                    myCalendarVM.changeMonth(newMonth: date)
                    
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
    func getTodayIndex() -> Int? {
        let todayDate = Date()
        
        let todayIndex = weeksToShow.firstIndex { date in
            return weeklyCalendarVM.compareFirstAndSecond(first: todayDate, second: date) == 0
        }
        
        return todayIndex
    }
}

private extension WeeklyCalendarView {
    @ViewBuilder
    func topToolbarView() -> some View {
        ZStack {
            Text("내 캘린더")
            
            HStack(spacing: 28) {
                Button {
                    myCalendarVM.changeSelectedDate(newSelectedDate: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            myCalendarVM.changeSelectedWeek(newSelectedWeek: [])
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                if let todayIndex = getTodayIndex(), !myCalendarVM.isSelectToday(){
                    Button {
                        let today = weeksToShow[todayIndex]
                        let newSelection: Int = todayIndex / 7
                        
                        self.isClickTodayButton = true
                        self.selection = newSelection
                        myCalendarVM.changeMonth(newMonth: today)
                        myCalendarVM.changeSelectedDate(newSelectedDate: today)
                    } label: {
                        Text("오늘")
                    }
                }
                
                Button {
                    self.isCreatingEvent = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
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
