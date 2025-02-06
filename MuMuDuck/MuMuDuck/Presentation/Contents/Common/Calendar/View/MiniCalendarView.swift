//
//  MiniCalendarView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import SwiftUI

struct MiniCalendarView: View {
    let calendarVM: MiniCalendarViewModel = MiniCalendarViewModel()
    @State var isGestured: Bool = false
    
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
