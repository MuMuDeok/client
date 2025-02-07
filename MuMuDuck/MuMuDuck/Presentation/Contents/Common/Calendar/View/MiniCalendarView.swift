//
//  MiniCalendarView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

struct MiniCalendarView: View {
    let calendarVM: MiniCalendarViewModel
    @State var isGestured: Bool = false
    
    init() {
        // mockEvents에 원하는 값의 Date타입을 만들기 위한 임시 함수
        func getDate(year: Int, month: Int, day: Int) -> Date {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            if let date = Calendar.current.date(from: dateComponents) {
                return date
            } else {
                return Date()
            }
        }
        
        let mockEvents: [any Event] = [
            PersonalEvent(title: "테스트1", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 8), endDate: getDate(year: 2025, month: 2, day: 9), isAlert: false),
            PersonalEvent(title: "테스트2", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 10), endDate: getDate(year: 2025, month: 2, day: 13), isAlert: false),
            PersonalEvent(title: "테스트3", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 12), endDate: getDate(year: 2025, month: 2, day: 13), isAlert: false),
            PersonalEvent(title: "테스트4", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 18), endDate: getDate(year: 2025, month: 2, day: 20), isAlert: false),
            PersonalEvent(title: "테스트5", isAllDay: false, startDate: getDate(year: 2025, month: 2, day: 21), endDate: getDate(year: 2025, month: 2, day: 21), isAlert: false),
        ]
        calendarVM = MiniCalendarViewModel(eventRepository: DefaultEventRepository(events: mockEvents))
    }
    
    var body: some View {
        VStack(spacing : 20) {
            MiniCalendarHeaderView(calendarVM: calendarVM)
            
            MiniCalendarBodyView(calendarVM: calendarVM)
        }
        .gesture(dragGesture)
    }
}

private extension MiniCalendarView {
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.location.x - gesture.startLocation.x > 100 && isGestured == false {
                    calendarVM.changeMonth(value: -1)
                    self.isGestured = true
                } else if gesture.location.x - gesture.startLocation.x < -100 && isGestured == false {
                    calendarVM.changeMonth(value: 1)
                    self.isGestured = true
                }
                print(gesture.location.x - gesture.startLocation.x)
            }
            .onEnded { _ in
                self.isGestured = false
            }
    }
}
