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
        let earlyDateYear = earlyDateCompoents.year!
        let lateDateYear = lateDateComponents.year!
        let earlyDateMonth = earlyDateCompoents.month!
        let lateDateMonth = lateDateComponents.month!
        let ealryDateDay = earlyDateCompoents.day!
        let lateDateDay = lateDateComponents.day!
        
        if earlyDateYear == lateDateYear {
            if earlyDateMonth == lateDateMonth {
                return ealryDateDay <= lateDateDay
            }
            return earlyDateMonth < lateDateMonth
        }
        return earlyDateYear < lateDateYear
    }
}
