//
//  SpreadedCalendarWeeklyEventView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/19/25.
//

import SwiftUI

struct BigCalendarWeeklyEventView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let myCalendarVM: MyCalendarTapViewModel
    
    let width: CGFloat = (UIScreen.main.bounds.width - 50) / 7
    let weekData: [CalendarDayEvents]
    let skipData: [[Bool]]
    let loopCount: Int
    
    init(myCalendarVM: MyCalendarTapViewModel, weekyleyDate: [Date]) {
        self.myCalendarVM = myCalendarVM
        
        let (weekData, skipData, loopCount) = myCalendarVM.getWeekData(date: weekyleyDate)
        self.weekData = weekData
        self.skipData = skipData
        self.loopCount = loopCount
    }
    
    var body: some View {
        VStack {
            ForEach(0..<max(loopCount, 2), id:\.self) { loopIndex in
                HStack(spacing: 1) {
                    ForEach(Array(weekData.enumerated()), id:\.element.id) { index, datas in
                        if loopIndex < loopCount && skipData[index][loopIndex] == false {
                            if let event = datas.events[loopIndex] {
                                Button {
                                    switch event.type {
                                    case .musical: break
                                        
                                    case .performance: break
                                        
                                    case .personal:
                                        coordinator.push(.personalEventDetail(event: event as! PersonalEvent))
                                    }
                                } label: {
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
