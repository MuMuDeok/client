//
//  SpreadedCalendarView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/12/25.
//

import SwiftUI

struct SpreadedCalendarView: View {
    let myCalendarVM: MyCalendarTapViewModel
    @Binding var month: Date
    @Binding var selectedDate: Date
    @State var isGestured: Bool = false
    let width: CGFloat = UIScreen.main.bounds.width / 7
    
    var body: some View {
        ScrollView {
            dateGridView()
        }
        .gesture(dragGesture)
    }
}

// 메서드
private extension SpreadedCalendarView {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.location.x - gesture.startLocation.x > 100 && isGestured == false {
                    month = myCalendarVM.changeMonth(month: month, value: -1)
                    self.isGestured = true
                } else if gesture.location.x - gesture.startLocation.x < -100 && isGestured == false {
                    month = myCalendarVM.changeMonth(month: month, value: 1)
                    self.isGestured = true
                }
                print(gesture.location.x - gesture.startLocation.x)
            }
            .onEnded { _ in
                self.isGestured = false
            }
    }
}

// 뷰
private extension SpreadedCalendarView {
    @ViewBuilder
    func weekView(weekData: [CalendarDayEvents], skipData: [[Bool]], loopCount: Int) -> some View {
        VStack {
            HStack(spacing: 1) {
                ForEach(weekData, id:\.id) { data in
                    Text("\(myCalendarVM.getDay(date: data.date))")
                        .font(.system(size: 14))
                        .foregroundStyle(myCalendarVM.isSameMonth(month: month, date: data.date) ? .black : .gray)
                        .frame(width: width)
                        .padding(.vertical, 5)
                }
            }
            
            VStack {
                ForEach(0..<max(loopCount, 2), id:\.self) { loopIndex in
                    HStack(spacing: 1) {
                        ForEach(Array(weekData.enumerated()), id:\.element.id) { index, datas in
                            if loopIndex < loopCount && skipData[index][loopIndex] == false {
                                if let event = datas.events[loopIndex] {
                                    // event가 원본 상태라서 시작날짜와 종료날짜가 해당 주 밖에 있을 수 있어서 몇일동안 진행되는지 새로운 startDate, endDate를 구해서 계산해야함
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(width: width * CGFloat(myCalendarVM.getContinueDay(
                                            eventStartDate: event.startDate, eventEndDate: event.endDate, weekStartDate: weekData[0].date, weekEndDate: weekData[6].date
                                        ) + 1) + CGFloat(myCalendarVM.getContinueDay(
                                            eventStartDate: event.startDate, eventEndDate: event.endDate, weekStartDate: weekData[0].date, weekEndDate: weekData[6].date
                                        )), height: 16)
                                        .foregroundStyle(Color.accentColor.opacity(0.7))
                                        .overlay {
                                            Text(event.title)
                                                .foregroundStyle(.white)
                                        }
                                } else {
                                    Rectangle()
                                        .frame(width: width, height: 16)
                                        .foregroundStyle(.clear)
                                }
                            } else if loopIndex >= loopCount {
                                Rectangle()
                                    .frame(width: width, height: 16)
                                    .foregroundStyle(.clear)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func dateGridView() -> some View {
        let days: [[Date]] = myCalendarVM.getCurrentMonthAllDate(month: month)
        
        VStack {
            ForEach(days, id: \.self) { dateArr in
                let (weekData, skipData, loopCount) = myCalendarVM.getWeekData(date: dateArr)
                
                weekView(weekData: weekData, skipData: skipData, loopCount: loopCount)
            }
        }
    }
}
