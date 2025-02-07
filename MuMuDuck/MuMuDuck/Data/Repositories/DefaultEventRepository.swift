//
//  DefaultEventRepository.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

class DefaultEventRepository: EventRepository {
    var events: [any Event]
    
    init(events: [any Event] = []) {
        self.events = events
    }
    
    func getEventsOfDay(day: Date) -> [any Event] {
        return []
    }
}
