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

protocol Event: Equatable, Hashable {
    var id: UUID { get }
    var title: String { get }
    var isAllDay: Bool { get }
    var startDate: Date { get }
    var endDate: Date { get }
    var alertTime: Int? { get }
    var type: EventType { get }
}

struct PersonalEvent: Event {
    let id: UUID = UUID()
    let title: String
    let isAllDay: Bool
    let startDate: Date
    let endDate: Date
    let alertTime: Int?
    let memo: String
    let type: EventType = .personal
    
    init(title: String, isAllDay: Bool, startDate: Date, endDate: Date, alertTime: Int?, memo: String = "") {
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.alertTime = alertTime
        self.memo = memo
    }
}

struct MusicalEvent: Event {
    let id: UUID = UUID()
    let title: String
    let isAllDay: Bool
    let startDate: Date
    let endDate: Date
    let alertTime: Int?
    let memo: String
    let url: String
    let type: EventType = .musical
    
    init(title: String, isAllDay: Bool, startDate: Date, endDate: Date, alertTime: Int?, memo: String = "", url: String = "") {
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.alertTime = alertTime
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
    let alertTime: Int?
    let actors: [String]
    let type: EventType = .performance
    
    init(title: String, isAllDay: Bool, startDate: Date, endDate: Date, alertTime: Int?, actors: [String]) {
        self.title = title
        self.isAllDay = isAllDay
        self.startDate = startDate
        self.endDate = endDate
        self.alertTime = alertTime
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
