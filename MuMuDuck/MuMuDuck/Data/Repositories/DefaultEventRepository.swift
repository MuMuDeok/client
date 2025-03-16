//
//  DefaultEventRepository.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

@Observable
class DefaultEventRepository: EventRepository {
    static let shared: DefaultEventRepository = DefaultEventRepository()
    private let persistenceController = PersistenceController.shared
    
    var events: [any Event]
    
    init() {
        let cd_events = persistenceController.fetchEvents()
        
        var newEvents: [any Event] = []
        for cd_event in cd_events {
            if cd_event.type == "personal" { // 나중에 다른 타입의 일정이 생기면 switch case로 나누기
                let event = PersonalEvent(id: cd_event.id, title: cd_event.title, isAllDay: cd_event.isAllDay, startDate: cd_event.startDate, endDate: cd_event.endDate, alertTime: Int(cd_event.alertTime), memo: cd_event.memo ?? "")
                
                newEvents.append(event)
            }
        }
        self.events = newEvents
    }
    
    func fetchEvents() -> [any Event] {
        let sortedEvents = self.events.sorted { (event1, event2) -> Bool in
            return event1.startDate < event2.startDate
        }
        return sortedEvents
    }
    
    func fetchEvent(id: UUID) -> any Event {
        if let index = self.events.firstIndex(where: { $0.id == id }) {
            return self.events[index]
        }
        
        return self.events[0]
    }
    
    func createEvent(event: any Event) {
        self.events.append(event)
    }
    
    func updateEvent(id: UUID, event: any Event) {
        if let index = self.events.firstIndex(where: { $0.id == id }) {
            self.events[index] = event
        }
    }
    
    func deleteEvent(id: UUID) {
        self.events = self.events.filter { $0.id != id }
    }
}
