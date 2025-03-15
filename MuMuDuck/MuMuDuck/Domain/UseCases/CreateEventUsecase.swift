//
//  CreateEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/12/25.
//
import SwiftUI

class CreateEventUsecase {
    private let eventRepository: EventRepository = DefaultEventRepository.shared
    private let notificationManager: NotificationManager = .shared
    private let persistenceController = PersistenceController.shared
    
    func execute(title: String, isAllDay: Bool, startDate: Date, endDate: Date, alertTime: Int?, memo: String = "") {
        let calendar = Calendar.current
        let endDateComponenets = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        var newEndDate: Date
        
        // 종료 날짜가 00:00인 경우 1분을 뺌 -> 12일 00:00에 끝난다 했을 때 12일의 이벤트로 포함시키지 않기 위함
        if endDateComponenets.hour == 0 && endDateComponenets.minute == 0, let convertedEndDate = calendar.date(byAdding: .minute, value: -1, to: endDate) {
            newEndDate = convertedEndDate
        } else {
            newEndDate = endDate
        }
        
        let newEvent = PersonalEvent(id: UUID(), title: title, isAllDay: isAllDay, startDate: startDate, endDate: newEndDate, alertTime: alertTime, memo: memo)
        
        eventRepository.createEvent(event: newEvent)
        notificationManager.addEventAlert(event: newEvent)
        persistenceController.addEvent(event: newEvent)
    }
}
