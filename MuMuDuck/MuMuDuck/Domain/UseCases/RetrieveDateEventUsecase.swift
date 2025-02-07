//
//  RetrieveDateEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

class RetrieveDateEventUsecase {
    private let eventRepository: EventRepository
    
    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository
    }
    
    func execute(date: Date) -> [any Event] {
        return eventRepository.getEventsOfDay(day: date)
    }
}
