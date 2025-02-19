//
//  RetrieveDateEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

class RetrieveDateEventUsecase {
    let eventRepository: EventRepository = DefaultEventRepository.shared
    
    func execute(date: Date) -> [any Event] {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let events: [any Event] = eventRepository.fetchEvents()
        
        let filteredEvents = events.filter { event in
            let startOfEvent = calendar.startOfDay(for: event.startDate)
            let endOfEvent = calendar.startOfDay(for: event.endDate)
            let day = calendar.startOfDay(for: date)
            
            if startOfEvent <= day && day <= endOfEvent{
                return true
            } else {
                return false
            }
        }
        
        return filteredEvents
    }
}
