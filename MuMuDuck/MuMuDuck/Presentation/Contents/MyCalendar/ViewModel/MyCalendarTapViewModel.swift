//
//  MyCalendarTapViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import Foundation

@Observable
class MyCalendarTapViewModel {
    private let retrieveDateEventUsecase:RetrieveDateEventUsecase  = RetrieveDateEventUsecase()
    private var isOutspread: Bool = false
    
    func isCalendarOutspread() -> Bool {
        return isOutspread
    }
    
    func toggleCalendarOutspread() {
        isOutspread.toggle()
    }
    
    func getDayEvents(date: Date) -> [any Event] {
        return retrieveDateEventUsecase.execute(date: date)
    }
}
