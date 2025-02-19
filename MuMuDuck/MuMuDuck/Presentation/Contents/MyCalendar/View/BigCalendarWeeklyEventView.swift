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
    let weeklyDate: [Date]
    
    let width: CGFloat = (UIScreen.main.bounds.width - 50) / 7
    
    
    init(myCalendarVM: MyCalendarTapViewModel, weekyleyDate: [Date]) {
        self.myCalendarVM = myCalendarVM
        self.weeklyDate = weekyleyDate
        
    }
    
    var body: some View {
        Text("SpreadedCalendarWeeklyEventView")
    }
}
