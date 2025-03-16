//
//  EventRepository.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

protocol EventRepository {
    func fetchEvent(id: UUID) -> any Event
    func fetchEvents() -> [any Event]
    func createEvent(event: any Event)
    func updateEvent(id: UUID, event: any Event)
    func deleteEvent(id: UUID)
}
