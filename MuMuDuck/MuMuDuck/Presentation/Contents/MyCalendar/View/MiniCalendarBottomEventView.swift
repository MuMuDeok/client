//
//  MiniCalendarBottomEventView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/20/25.
//

import SwiftUI

struct MiniCalendarBottomEventView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let myCalendarVM: MyCalendarTapViewModel
    @Binding var selectedDate: Date?
    var events: [any Event] {
        if let selectDate = self.selectedDate {
            return myCalendarVM.getDayEvents(date: selectDate)
        } else {
            return []
        }
    }
    
    var body: some View {
        if self.selectedDate != nil {
            VStack {
                eventListHeaderView()
                
                if events.isEmpty {
                    Text("등록된 일정이 없습니다.")
                        .padding(.top, 50)
                } else {
                    ForEach(events, id:\.id) { event in
                        eventListItemView(event: event)
                    }
                }
            }
            .padding(.top, 20)
        }
    }
}

extension MiniCalendarBottomEventView {
    @ViewBuilder
    func eventListHeaderView() -> some View {
        HStack {
            Text(dateToString(date: selectedDate!, format: "M.d (E)"))
            
            Spacer()
        }
        .font(.title2)
        .foregroundStyle(.black)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func eventListItemView(event: any Event) -> some View {
        Button {
            switch event.type {
            case .musical: break
            case .performance: break
            case .personal:
                coordinator.push(.personalEventDetail(event: event as! PersonalEvent))
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color(uiColor: .systemGray3))
                
                HStack(alignment: .center) {
                    Text(event.title)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 20)
            }
            .frame(height: 80)
            .padding(.horizontal, 20)
        }
    }
    
    func dateToString(date:Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
}
