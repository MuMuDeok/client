//
//  EventDetailViewModel.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/16/25.
//

import SwiftUI

class EventDetailViewModel {
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
