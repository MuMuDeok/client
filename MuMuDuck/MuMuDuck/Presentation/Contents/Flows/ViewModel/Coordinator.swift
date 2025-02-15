//
//  Coordinator.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import SwiftUI

enum Destination: Hashable{
    case personalEventDetail(event: PersonalEvent)
}

class Coordinator: ObservableObject {
    @Published var todayPath: NavigationPath = NavigationPath()
    @Published var interestPath: NavigationPath = NavigationPath()
    @Published var myCalendarPath: NavigationPath = NavigationPath()
    @Published var historyPath: NavigationPath = NavigationPath()
    @Published var selection: Int = 0
    
    func push(_ view: Destination) {
        switch selection {
        case 0:
            todayPath.append(view)
        case 1:
            interestPath.append(view)
        case 2:
            myCalendarPath.append(view)
        case 3:
            historyPath.append(view)
        default:
            break
        }
    }
    
    func pop() {
        switch selection {
        case 0:
            if todayPath.isEmpty == false {
                todayPath.removeLast()
            }
        case 1:
            if interestPath.isEmpty == false {
                interestPath.removeLast()
            }
        case 2:
            if myCalendarPath.isEmpty == false {
                myCalendarPath.removeLast()
            }
        case 3:
            if historyPath.isEmpty == false {
                historyPath.removeLast()
            }
        default:
            break
        }
    }
    
    func popToRoot() {
        switch selection {
        case 0:
            todayPath.removeLast(todayPath.count)
        case 1:
            interestPath.removeLast(interestPath.count)
        case 2:
            myCalendarPath.removeLast(myCalendarPath.count)
        case 3:
            historyPath.removeLast(historyPath.count)
        default:
            break
        }
    }
    
    @ViewBuilder
    func handleDestination(_ destination: Destination) -> some View {
        switch destination {
        case .personalEventDetail(let event):
            PersonalEventDetailView(event: event)
        }
    }
}
