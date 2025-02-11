//
//  Event.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/7/25.
//

import Foundation

enum EventType {
    case personal
    case musical
    case performance
}

protocol Event: Equatable {
    var id: UUID { get }
    var title: String { get }
    var isAllDay: Bool { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var isAlert: Bool { get }
    var type: EventType { get }
}

struct PersonalEvent: Event {
    let id: UUID = UUID()
    let title: String
    let isAllDay: Bool
    let startDate: Date
    let endDate: Date
    let isAlert: Bool
    let memo: String
    let type: EventType = .personal
    
    init(title: String, isAllDay: Bool, startDate: Date, endDate: Date, isAlert: Bool, memo: String = "") {
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.isAlert = isAlert
        self.memo = memo
    }
}

struct MusicalEvent: Event {
    let id: UUID = UUID()
    let title: String
    let isAllDay: Bool
    let startDate: Date
    let endDate: Date
    let isAlert: Bool
    let memo: String
    let url: String
    let type: EventType = .musical
    
    init(title: String, isAllDay: Bool, startDate: Date, endDate: Date, isAlert: Bool, memo: String = "", url: String = "") {
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.isAlert = isAlert
        self.memo = memo
        self.url = url
    }
}

struct PerformanceEvent: Event {
    let id: UUID = UUID()
    let title: String
    let isAllDay: Bool
    let startDate: Date
    let endDate: Date
    let isAlert: Bool
    let actors: [String]
    let type: EventType = .performance
    
    init(title: String, isAllDay: Bool, startDate: Date, endDate: Date, isAlert: Bool, actors: [String]) {
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.isAlert = isAlert
        self.actors = actors
    }
}

struct CalendarDayEvents {
    let id: UUID = UUID()
    let date: Date
    var events: [(any Event)?]
    
    init(date: Date, events: [(any Event)?]) {
        self.date = date
        self.events = events
    }
}
