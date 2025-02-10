//
//  MyCalendarTapViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import Foundation

@Observable
class MyCalendarTapViewModel {
    private let eventrepository: EventRepository
    private var isOutspread: Bool = false
    
    init() {
        self.eventrepository = DefaultEventRepository.shared
    }
    
    func isCalendarOutspread() -> Bool {
        return isOutspread
    }
    
    func toggleCalendarOutspread() {
        isOutspread.toggle()
    }
}
