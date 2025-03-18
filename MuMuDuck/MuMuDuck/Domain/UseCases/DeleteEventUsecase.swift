//
//  DeleteEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import SwiftUI

class DeleteEventUsecase {
    private let eventRepository: EventRepository = DefaultEventRepository.shared
    private let notificationManager: NotificationManager = .shared
    private let persistenceController = PersistenceController.shared
    
    func execute(event: any Event) {
        let id = event.id
        
        eventRepository.deleteEvent(id: id)
        notificationManager.removeEventAlert(id: id)
        persistenceController.deleteEvent(event: event)
    }
}
