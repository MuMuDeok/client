//
//  RetrieveMonthEventUsecases.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/12/25.
//

import SwiftUI

class RetrieveWeekEventUsecase {
    private let eventRepository: EventRepository = DefaultEventRepository.shared
    
    func execute(date: [Date]) -> [any Event] {
        let calendar = Calendar.current
        let events: [any Event] = eventRepository.fetchEvents()
        
        let wsd = calendar.dateComponents([.year, .month, .day], from: date[0])
        let wed = calendar.dateComponents([.year, .month, .day], from: date[6])
        var filterdEvents: [any Event] = []
        let forMatter = "yyyy-MM-dd"
        
        events.forEach { event in
            let esd = calendar.dateComponents([.year, .month, .day], from: event.startDate)
            let eed = calendar.dateComponents([.year, .month, .day], from: event.endDate)
            
            if (compareDateComponents(esd, wsd) && compareDateComponents(wsd, eed)) || (compareDateComponents(esd, wed) && compareDateComponents(wed, eed) || (compareDateComponents(wsd, esd) && compareDateComponents(esd, wed))) {
                filterdEvents.append(event)
            }
        }
        
        return filterdEvents
    }
    
    private func compareDateComponents(_ date1: DateComponents, _ date2: DateComponents) -> Bool {
        let y1 = date1.year!
        let y2 = date2.year!
        let m1 = date1.month!
        let m2 = date2.month!
        let d1 = date1.day!
        let d2 = date2.day!
        
        if y1 == y2 {
            if m1 == m2 {
                return d1 <= d2
            }
            return m1 < m2
        }
        return y1 < y2
    }
}
