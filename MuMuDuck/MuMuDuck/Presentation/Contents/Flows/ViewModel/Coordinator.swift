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
    @Published var todayPath: NavigationPath = NavigationPath() // 메인(?) 뷰 탭 이름이 변경되면 변수명도 수정할 것 같아요
    @Published var interestPath: NavigationPath = NavigationPath() // 관심 탭
    @Published var myCalendarPath: NavigationPath = NavigationPath() // 내 캘린더 탭
    @Published var historyPath: NavigationPath = NavigationPath() // 관극 기록 탭
    @Published var selection: Int = 0
    // 탭 별로 별도의 네비게이션 스택을 사용하는데 selection 값으로 현재 무슨 탭을 사용하고 있는지 구분해서 탭에 해당하는 스택을 관리합니다.
    
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
