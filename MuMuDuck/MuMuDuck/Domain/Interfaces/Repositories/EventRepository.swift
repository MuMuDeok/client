//
//  EventRepository.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

protocol EventRepository {
    func fetchEvents() -> [any Event]
    func createEvent(event: any Event)
}
