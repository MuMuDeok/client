//
//  UpdateEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import SwiftUI

class UpdateEventUsecase {
    private let eventRepository: EventRepository = DefaultEventRepository.shared
    private let notificationManager: NotificationManager = .shared
    private let persistenceController = PersistenceController.shared
    
    func execute(event: any Event) {
        let id = event.id
        
        eventRepository.updateEvent(id: id, event: event)
        notificationManager.updateEventAlert(event: event)
        persistenceController.updateEvent(event: event)
    }
}
