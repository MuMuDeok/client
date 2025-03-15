//
//  EventDetailViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/16/25.
//

import SwiftUI

class EventDetailViewModel {
    private let readEventUsecase: ReadEventUsecase = ReadEventUsecase()
    private let updateEventUsecase: UpdateEventUsecase = UpdateEventUsecase()
    
    func fetchEvent(id: UUID) -> any Event {
        readEventUsecase.execute(id: id)
    }
    
    func updateEvent(event: any Event) {
        switch event.type {
        case .personal:
            updateEventUsecase.execute(event: event as! PersonalEvent)
        case .musical:
            updateEventUsecase.execute(event: event as! MusicalEvent)
        case .performance:
            updateEventUsecase.execute(event: event as! PerformanceEvent)
        }
    }
    
    func convertEventDateToString(event: any Event) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: event.startDate)
    }
    
    func convertEventTimeToString(event: any Event) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: event.startDate)
    }
}
