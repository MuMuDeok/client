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
        let calendar = Calendar.current
        let events: [any Event] = eventRepository.fetchEvents()
        
        let filteredEvents = events.filter { event in
            // 이벤트의 시작날짜와 종료날짜의 차이 eventPeriod
            let diffWithStartAndEnd = calendar.dateComponents([.day], from: event.startDate, to: event.endDate)
            
            // 이벤트의 시작날짜와 인자로 넘긴 날짜의 차이 diffDayFromEventStart
            let diffWithStartAndDay = calendar.dateComponents([.day], from: event.startDate, to: date)
            
            // diffDayFromEventStart가 음수일 경우 이벤트의 시작 날짜보다 앞에 있음, eventPeriod보다 클 경우 이벤트의 종료 날짜보다 뒤에 있음
            guard let eventPeriod = diffWithStartAndEnd.day, let diffDayFromEventStart = diffWithStartAndDay.day else {
                return false
            }
            
            print(eventPeriod, diffDayFromEventStart)
            
            if 0 <= diffDayFromEventStart && diffDayFromEventStart <= eventPeriod{
                return true
            } else {
                return false
            }
        }
        
        return filteredEvents
    }
}
