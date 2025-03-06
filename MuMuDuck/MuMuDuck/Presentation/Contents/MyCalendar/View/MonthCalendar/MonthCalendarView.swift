//
//  MonthCalendarView.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/6/25.
//

import SwiftUI

struct MonthCalendarView: View {
    let myCalendarVM: MyCalendarTapViewModel
    let monthCalendarVM: MonthCalendarViewModel
    @Binding var isCreatingEvent: Bool
    
    @State var isGestured: Bool = false
    
    var currentMonthDays: [[Date]] { monthCalendarVM.getCurrentMonthAllDate(month: myCalendarVM.month) }
    
    var body: some View {
        ZStack {
            VStack {
                topToolbarView() // 타이틀, 일정 추가 버튼
                
                Divider()
                
                ScrollView {
                    MonthCalendarHeaderView(myCalendarVM: myCalendarVM, monthCalendarVM: monthCalendarVM)
                    
                    ForEach(currentMonthDays, id: \.self) { weeklyDate in
                        // 애니메이션을 위해 2번째 조건인 펼친 달력에서 주말을 선택한 경우를 조건으로 둠
                        if myCalendarVM.selectedWeek.isEmpty || (myCalendarVM.selectedWeek == weeklyDate && myCalendarVM.selectedDate == nil) {
                            VStack {
                                MonthCalendarWeekView(myCalendarVM: myCalendarVM, monthCalendarVM: monthCalendarVM, weeklyDate: weeklyDate)
                                    .padding(.horizontal, 20)
                                
                                if monthCalendarVM.isOutspread && myCalendarVM.selectedWeek.isEmpty { // 달력 펼친 상태
                                    BigCalendarWeeklyEventView(myCalendarVM: myCalendarVM, monthCalendarVM: monthCalendarVM, weekyleyDate: weeklyDate)
                                } else { // 달력 접힌 상태
                                    MiniCalendarWeeklyEventView(myCalendarVM: myCalendarVM, weeklyDate: weeklyDate)
                                }
                            }
                        }
                    }
                    .gesture(dragGesture)
                    .animation(.easeInOut, value: myCalendarVM.selectedWeek)
                    
                    if monthCalendarVM.isOutspread == false && myCalendarVM.selectedDate != nil {
                        toggleOutspreadButton()
                        
                        MiniCalendarBottomEventView(myCalendarVM: myCalendarVM)
                    }
                }
                .scrollDisabled(monthCalendarVM.isChangingMonthAndYear)
                
                Spacer()
                
                if monthCalendarVM.isOutspread && myCalendarVM.selectedWeek.isEmpty {
                    toggleOutspreadButton()
                }
            }
            .blur(radius: monthCalendarVM.isChangingMonthAndYear ? 5 : 0)
            
            if monthCalendarVM.isChangingMonthAndYear {
                GeometryReader { proxy in
                    ZStack {
                        Rectangle()
                            .foregroundStyle(.black.opacity(0.4))
                            .onTapGesture {
                                monthCalendarVM.toggleIsChangingMonthAndYear()
                            }
                        
                        ChangeMonthAndYearView(myCalendarVM: myCalendarVM, monthCalendarVM: monthCalendarVM)
                    }
                    .ignoresSafeArea()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
        }
    }
}

private extension MonthCalendarView {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                isGestured = true
                
                if gesture.location.x - gesture.startLocation.x > 100 && isGestured == false {
                    let newMonth = monthCalendarVM.getChangeMonth(month: myCalendarVM.month, value: -1)
                    myCalendarVM.changeMonth(newMonth: newMonth)
                    
                    self.isGestured = true
                } else if gesture.location.x - gesture.startLocation.x < -100 && isGestured == false {
                    let newMonth = monthCalendarVM.getChangeMonth(month: myCalendarVM.month, value: 1)
                    myCalendarVM.changeMonth(newMonth: newMonth)
                    
                    self.isGestured = true
                }
            }
            .onEnded { _ in
                self.isGestured = false
            }
    }
}

private extension MonthCalendarView {
    @ViewBuilder
    func topToolbarView() -> some View {
        ZStack {
            Text("내 캘린더")
            
            HStack {
                Spacer()
                
                Button {
                    self.isCreatingEvent = true
                } label: {
                    Image(systemName: "plus")
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
        if monthCalendarVM.isOutspread {
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                
                Button {
                    myCalendarVM.changeSelectedDate(newSelectedDate: Date())
                    
                    withAnimation {
                        monthCalendarVM.toggleIsOutspread()
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
                    myCalendarVM.changeSelectedDate(newSelectedDate: nil)
                    
                    withAnimation {
                        monthCalendarVM.toggleIsOutspread()
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
