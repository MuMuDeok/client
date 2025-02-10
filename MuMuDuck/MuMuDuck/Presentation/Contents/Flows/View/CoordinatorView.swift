//
//  CoordinatorView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationStack(path: $coordinator.todayPath) {
                TodayTapView()
                    .navigationDestination(for: Destination.self) { destination in
                        coordinator.handleDestination(destination)
                    }
            }
            .tabItem {
                Image(selection == 0 ? "Today_fill" : "Today")
                Text("오늘")
            }
            .tag(0)
            
            NavigationStack(path: $coordinator.interestPath) {
                InterestTapView()
                    .navigationDestination(for: Destination.self) { destination in
                        coordinator.handleDestination(destination)
                    }
            }
            .tabItem {
                Image(selection == 1 ? "Interest_fill" : "Interest")
                Text("관심OO")
            }
            .tag(1)
            
            NavigationStack(path: $coordinator.myCalendarPath) {
                MyCalendarTapView()
                    .navigationDestination(for: Destination.self) { destination in
                        coordinator.handleDestination(destination)
                    }
            }
            .tabItem {
                Image(selection == 2 ? "MyCalendar_fill" : "MyCalendar")
                Text("내 캘린더")
            }
            .tag(2)
            
            NavigationStack(path: $coordinator.historyPath) {
                HistoryTapView()
                    .navigationDestination(for: Destination.self) { destination in
                        coordinator.handleDestination(destination)
                    }
            }
            .tabItem {
                Image(selection == 3 ? "History_fill" : "History")
                Text("관극 기록")
            }
            .tag(3)
        }
        .onChange(of: selection) {
            coordinator.selection = selection
        }
    }
}
