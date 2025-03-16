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
    private let deleteEventUsecase: DeleteEventUsecase = DeleteEventUsecase()
    
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
    
    func deleteEvent(event: any Event) {
        deleteEventUsecase.execute(event: event)
    }
    
    func convertEventDateToString(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 (E)"
        return formatter.string(from: time)
    }
    
    func convertEventTimeToString(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: time)
    }
    
    func convertEventAlertToString(time: Int?) -> String {
        guard let alertTime = time else {
            return "없음"
        }
        
        if alertTime == 0 {
            return "이벤트 시작"
        } else if alertTime < 60 {
            return "\(alertTime)분 전"
        } else {
            return "\(alertTime / 60)시간 전"
        }
    }
}
