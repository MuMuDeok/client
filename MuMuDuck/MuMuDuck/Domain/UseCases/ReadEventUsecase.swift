//
//  ReadEventUsecase.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import SwiftUI

class ReadEventUsecase {
    private let eventRepository: EventRepository = DefaultEventRepository.shared
    
    func execute(id: UUID) -> any Event {
        return eventRepository.fetchEvent(id: id)
    }
}
