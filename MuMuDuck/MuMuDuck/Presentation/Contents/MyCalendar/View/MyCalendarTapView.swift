//
//  MyCalendarTapView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import SwiftUI

struct MyCalendarTapView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State var myCalendarVM: MyCalendarTapViewModel = MyCalendarTapViewModel()
    @State private var month: Date = Date()
    @State private var selectedDate: Date = Date()
    @State var isCreatingEvent: Bool = false
    let width = UIScreen.main.bounds.width * 0.9
    
    var body: some View {
        VStack {
            hearderView()
            
            Divider()
            
            CalendarHeaderView(month: $month)
            
            if myCalendarVM.isCalendarOutspread() { // 달력 펼친 상태
                SpreadedCalendarView(myCalendarVM: myCalendarVM, month: $month, selectedDate: $selectedDate)
                
            } else { // 달력 접힌 상태
                ScrollView {
                    VStack { 
                        MiniCalendarView(month: $month, selectedDate: $selectedDate)
                        
                        toggleOutspreadButton()
                        
                        miniCalendarEventListView()
                    }
                }
                .scrollDisabled(myCalendarVM.getDayEvents(date: selectedDate).count < 3)
            }
        }
        .sheet(isPresented: $isCreatingEvent, content: {
            CreateEventView(myCalendarVM: myCalendarVM, selectedDate: selectedDate)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if myCalendarVM.isCalendarOutspread() {
                ToolbarItem(placement: .bottomBar) {
                    toggleOutspreadButton()
                }
            }
        }
    }
}

private extension MyCalendarTapView {
    @ViewBuilder
    func hearderView() -> some View {
        ZStack {
            Text("내 캘린더")
            
            HStack {
                Spacer()
                
                Button {
                    self.isCreatingEvent.toggle()
                } label: {
                    Image(systemName: "plus.app")
                        .foregroundStyle(.black)
                        .font(.system(size: 20))
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder
    func toggleOutspreadButton() -> some View {
        // 접기 버튼
        if myCalendarVM.isCalendarOutspread() {
            ZStack {
                Rectangle()
                    .foregroundStyle(.white)
                
                Button {
                    myCalendarVM.toggleCalendarOutspread()
                } label: {
                    Image(systemName: "chevron.up")
                        .foregroundStyle(.black)
                }
            }
            .frame(height: 20)
            .frame(maxWidth: .infinity)
        } else { // 확장 버튼
            ZStack {
                Capsule()
                    .fill(.white)
                    .shadow(color: Color(uiColor: .systemGray4), radius: 1, y:3)
                
                Button {
                    myCalendarVM.toggleCalendarOutspread()
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.black)
                }
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func eventListHeaderView() -> some View {
        HStack {
            Text(dateToString(date: selectedDate, format: "M.d (E)"))
            
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
    
    @ViewBuilder
    func miniCalendarEventListView() -> some View {
        let events = myCalendarVM.getDayEvents(date: selectedDate)
        
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
    
    func dateToString(date:Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: date)
    }
}
