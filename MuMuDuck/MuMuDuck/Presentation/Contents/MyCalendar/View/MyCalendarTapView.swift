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
    @State private var month: Date = Date()
    @State private var selectedDate: Date? = Date()
    @State private var selectedWeek: [Date] = []
    @State var isCreatingEvent: Bool = false
    @State var isOutspread: Bool = false
    @State var isGestured: Bool = false
    let width = UIScreen.main.bounds.width * 0.9
    var currentMonthDays: [[Date]] { myCalendarVM.getCurrentMonthAllDate(month: month) }
    
    var body: some View {
        VStack {
            hearderView() // 타이틀, 일정 추가 버튼
            
            Divider()
            
            ScrollView {
                CalendarHeaderView(month: $month, isSelectWeek: self.selectedWeek.isEmpty == false) // 월
                
                ForEach(currentMonthDays, id: \.self) { weeklyDate in
                    if selectedWeek.isEmpty || selectedWeek == weeklyDate {
                        VStack {
                            WeeklyDayView(month: $month, selectedDate: $selectedDate, selectedWeek: $selectedWeek, isOutspread: $isOutspread, weeklyDate: weeklyDate)
                            
                            if self.isOutspread { // 달력 펼친 상태
                                if self.selectedWeek.isEmpty { // 전체 달력을 보여줄 때
                                    BigCalendarWeeklyEventView(myCalendarVM: myCalendarVM, weekyleyDate: weeklyDate)
                                }
                            } else { // 달력 접힌 상태
                                MiniCalendarWeeklyEventView(calendarVM: myCalendarVM, month: $month, selectedDate: $selectedDate, weeklyDate: weeklyDate)
                            }
                        }
                    }
                }
                .gesture(dragGesture)
                .animation(.easeInOut, value: self.selectedWeek)
                
                if self.isOutspread == false {
                    toggleOutspreadButton()
                    
                    MiniCalendarBottomEventView(myCalendarVM: myCalendarVM, selectedDate: $selectedDate)
                }
            }
        }
        .sheet(isPresented: $isCreatingEvent, content: {
            CreateEventView(myCalendarVM: myCalendarVM, selectedDate: self.selectedDate ?? Date())
        })
        .scrollDisabled(self.selectedWeek.isEmpty == false)
        .toolbar {
            if self.isOutspread && self.selectedWeek.isEmpty {
                ToolbarItem(placement: .bottomBar) {
                    toggleOutspreadButton()
                }
            }
        }
    }
}

private extension MyCalendarTapView {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if self.selectedWeek.isEmpty == false {
                    isGestured = true
                }
                
                if gesture.location.x - gesture.startLocation.x > 100 && isGestured == false {
                    month = myCalendarVM.changeMonth(month: month, value: -1)
                    self.isGestured = true
                } else if gesture.location.x - gesture.startLocation.x < -100 && isGestured == false {
                    month = myCalendarVM.changeMonth(month: month, value: 1)
                    self.isGestured = true
                }
            }
            .onEnded { _ in
                self.isGestured = false
            }
    }
}

private extension MyCalendarTapView {
    @ViewBuilder
    func hearderView() -> some View {
        ZStack {
            Text("내 캘린더")
            
            HStack {
                if self.selectedWeek.isEmpty == false {
                    Button {
                        self.selectedDate = nil
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.selectedWeek.removeAll()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                }
                
                Spacer()
                
                Button {
                    self.isCreatingEvent.toggle()
                } label: {
                    Image(systemName: "plus.app")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    @ViewBuilder
    func toggleOutspreadButton() -> some View {
        // 접기 버튼
        if self.isOutspread {
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                
                Button {
                    self.selectedDate = Date()
                    
                    withAnimation {
                        self.isOutspread.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.up")
                        .foregroundStyle(.black)
                }
            }
            .frame(height: 20)
            .frame(maxWidth: .infinity)
        } else { // 확장 버튼
            ZStack {
                Capsule()
                    .fill(.white)
                    .shadow(color: Color(uiColor: .systemGray4), radius: 1, y:3)
                
                Button {
                    self.selectedDate = nil
                    
                    withAnimation {
                        self.isOutspread.toggle()
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
}
