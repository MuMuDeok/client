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
            
            if (isLateOrSameDate(esd, wsd) && isLateOrSameDate(wsd, eed)) || (isLateOrSameDate(esd, wed) && isLateOrSameDate(wed, eed) || (isLateOrSameDate(wsd, esd) && isLateOrSameDate(esd, wed))) {
                filterdEvents.append(event)
            }
        }
        
        return filterdEvents
    }
    
    private func isLateOrSameDate(_ earlyDateCompoents: DateComponents, _ lateDateComponents: DateComponents) -> Bool {
        let y1 = earlyDateCompoents.year!
        let y2 = lateDateComponents.year!
        let m1 = earlyDateCompoents.month!
        let m2 = lateDateComponents.month!
        let d1 = earlyDateCompoents.day!
        let d2 = lateDateComponents.day!
        
        if y1 == y2 {
            if m1 == m2 {
                return d1 <= d2
            }
            return m1 < m2
        }
        return y1 < y2
    }
}
