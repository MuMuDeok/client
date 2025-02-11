//
//  CreateEventView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/12/25.
//

import SwiftUI

struct CreateEventView: View {
    @Environment(\.dismiss) var dismiss
    
    let myCalendarVM: MyCalendarTapViewModel
    
    @State var title: String = ""
    @State var isAllDay: Bool = false
    @State var startDate: Date
    @State var endDate: Date
    @State var isAlert: Bool = false
    @State var memo: String = ""
    @State var eventType: EventType
    
    init(myCalendarVM: MyCalendarTapViewModel, selectedDate: Date, title: String = "", isAllDay: Bool = false, startDate: Date? = nil, endDate: Date? = nil, isAlert: Bool = false, memo: String = "", eventType: EventType = .personal) {
        self.myCalendarVM = myCalendarVM
        self.title = title
        self.isAllDay = isAllDay
        self.isAlert = isAlert
        self.memo = memo
        self.eventType = eventType
        
        if let newStartDate = startDate, let newEndDate = endDate {
            self.startDate = newStartDate
            self.endDate = newEndDate
        } else {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: Date())
            
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            dateComponents.hour = hour
            
            if let newDate = calendar.date(from: dateComponents) {
                self.startDate = newDate.addingTimeInterval(3600)
                self.endDate = newDate.addingTimeInterval(7200) // 시작 시간으로부터 1시간 뒤
            } else {
                self.startDate = selectedDate
                self.endDate = selectedDate.addingTimeInterval(3600)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            ToorbarView()
            
            TitleView()
            
            EventOptionSettingView()
            
            MemoView()
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

private extension CreateEventView{
    @ViewBuilder
    func ToorbarView() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "multiply")
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Button {
                // 나중에 뮤지컬 일정, 공연 일정 추가할 때 switch case와 eventType을 이용해서 어떤 이벤트인지 구별
                myCalendarVM.createPersonalEvent(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, isAlert: isAlert, memo: memo)
                dismiss()
            } label: {
                Text("저장")
            }
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func TitleView() -> some View {
        VStack(spacing: 5) {
            TextField("제목", text: $title)
                .font(.title)
            Divider()
        }
    }
    
    @ViewBuilder
    func EventOptionSettingView() -> some View {
        VStack(spacing: 25) {
            Toggle("종일", isOn: $isAllDay)
            
            DatePicker("시작", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                .environment(\.locale, Locale(identifier: "ko"))
            
            DatePicker("종료", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                .environment(\.locale, Locale(identifier: "ko"))
            
            Toggle("알림설정", isOn: $isAlert)
            
            Divider()
        }
        .font(.title3)
    }
    
    @ViewBuilder
    func MemoView() -> some View {
        VStack(alignment: .leading) {
            Text("메모")
                .font(.title2)
            
            TextField("메모를 입력해주세요.", text: $memo, axis: .vertical)
        }
    }
}
