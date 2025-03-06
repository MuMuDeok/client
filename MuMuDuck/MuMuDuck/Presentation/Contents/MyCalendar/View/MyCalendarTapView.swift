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
    @State var isChangingMonthAndYear: Bool = false
    @State var isOutspread: Bool = false
    @State var isGestured: Bool = false
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var currentMonthDays: [[Date]] { myCalendarVM.getCurrentMonthAllDate(month: month) }
    
    var body: some View {
        VStack {
            // 주간 캘린더
            if self.selectedWeek.isEmpty == false && self.selectedDate != nil {
                hearderView() // 타이틀, 일정 추가 버튼
                
                Divider()
                
                WeeklyCalendarView(myCalendarVM: myCalendarVM, month: self.$month, isChangingMonthAndYear: $isChangingMonthAndYear, selectedDate: self.$selectedDate, selectedWeek: self.$selectedWeek)
            } else { // 월간 캘린더
                ZStack {
                    // 타이틀까지 블러처리하기 위해 VStack안에 headerView 넣기
                    VStack {
                        hearderView() // 타이틀, 일정 추가 버튼
                        
                        Divider()
                        
                        ScrollView {
                            CalendarHeaderView(month: $month, isChangingMonthAndYear: $isChangingMonthAndYear, isSelectWeek: self.selectedWeek.isEmpty == false) // 월
                            
                            ForEach(currentMonthDays, id: \.self) { weeklyDate in
                                // 애니메이션을 위해 2번째 조건인 펼친 달력에서 주말을 선택한 경우를 조건으로 둠
                                if selectedWeek.isEmpty || (selectedWeek == weeklyDate && self.selectedDate == nil) {
                                    VStack {
                                        WeeklyDayView(month: $month, selectedDate: $selectedDate, selectedWeek: $selectedWeek, isOutspread: isOutspread, weeklyDate: weeklyDate)
                                            .padding(.horizontal, 20)
                                        
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
                        .scrollDisabled(self.selectedWeek.isEmpty == false || isChangingMonthAndYear)
                        
                        Spacer()
                        
                        if self.isOutspread && self.selectedWeek.isEmpty {
                            toggleOutspreadButton()
                        }
                    }
                    .blur(radius: isChangingMonthAndYear ? 5 : 0)
                    
                    if self.isChangingMonthAndYear {
                        GeometryReader { proxy in
                            ZStack {
                                Rectangle()
                                    .foregroundStyle(.black.opacity(0.4))
                                    .onTapGesture {
                                        self.isChangingMonthAndYear = false
                                    }
                                
                                ChangeMonthAndYearView(month: self.$month, isChangingMonthAndYear: $isChangingMonthAndYear)
                            }
                            .ignoresSafeArea()
                            .frame(width: proxy.size.width, height: proxy.size.height)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isCreatingEvent, content: {
            CreateEventView(myCalendarVM: myCalendarVM, selectedDate: self.selectedDate ?? Date())
        })
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
