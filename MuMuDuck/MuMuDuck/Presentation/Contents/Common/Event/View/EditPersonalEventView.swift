//
//  UpdateEventView.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import SwiftUI

struct EditPersonalEventView: View {
    @Environment(\.dismiss) var dismiss
    
    let eventDetailVM: EventDetailViewModel
    let id: UUID
    var alertTimes: [Int?] = [nil, 0, 5, 10, 15, 30, 60, 120]
    
    @State var title: String = ""
    @State var isAllDay: Bool = false
    @State var startDate: Date
    @State var endDate: Date
    @State var alertTime: Int? = nil
    @State var memo: String = ""
    @State var eventType: EventType
    @FocusState private var focusField: FocusField?
    @State private var focusComponent: FocusComponent?
    
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
    
    init(eventDetailVM: EventDetailViewModel, event: PersonalEvent) {
        self.eventDetailVM = eventDetailVM
        self.id = event.id
        self.title = event.title
        self.isAllDay = event.isAllDay
        self.startDate = event.startDate
        self.endDate = event.endDate
        self.alertTime = event.alertTime
        self.memo = event.memo
        self.eventType = event.type
    }
    
    var body: some View {
        VStack(spacing: 40) {
            ToorbarView()
            
            ScrollView {
                TitleView()
                
                EventOptionSettingView()
                
                MemoView()
                
                Spacer()
            }
            .scrollDisabled(focusComponent == nil)
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 16)
        .onAppear {
            self.focusField = .title
            UIDatePicker.appearance().minuteInterval = 5
        }
        .onChange(of: self.isAllDay) {
            if focusComponent == .startTime || focusComponent == .endTime {
                withAnimation {
                    focusComponent = nil
                }
            }
        }
    }
}

private extension EditPersonalEventView {
    enum FocusField: Hashable {
        case title
        case memo
    }
    
    enum FocusComponent: Hashable {
        case startDate
        case startTime
        case endDate
        case endTime
    }
    
    func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd."
        return formatter.string(from: date)
    }
    
    func timeToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    func alertTimeToString(alertTime: Int?) -> String {
        guard let time = alertTime else {
            return "없음"
        }
        
        if time == 0 {
            return "시작"
        }
        
        let hour = time / 60
        let minute = time % 60
        
        if hour != 0 {
            return "\(hour)시간 전"
        }
        
        return "\(minute)분 전"
    }
}

private extension EditPersonalEventView {
    @ViewBuilder
    func ToorbarView() -> some View {
        HStack {
            Spacer()
            
            Button {
                let newEvent = PersonalEvent(id: id, title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, alertTime: alertTime, memo: memo)
                
                eventDetailVM.updateEvent(event: newEvent)
                dismiss()
            } label: {
                Text("저장")
            }
            .disabled(title.isEmpty)
        }
        .padding(.top, 20)
    }
    
    @ViewBuilder
    func TitleView() -> some View {
        VStack(spacing: 5) {
            TextField("제목", text: $title)
                .font(.title)
                .focused($focusField, equals: .title)
            
            Divider()
        }
    }
    
    @ViewBuilder
    func EventOptionSettingView() -> some View {
        VStack(spacing: 15) {
            Toggle("종일", isOn: $isAllDay)
                .tint(.accent)
                .padding(.trailing, 1.5)
            
            dateView(title: "시작", date: $startDate, focusDate: .startDate, focusTime: .startTime)
            
            dateView(title: "종료", date: $endDate, focusDate: .endDate, focusTime: .endTime)
            
            HStack {
                Text("알림설정")
                
                Spacer()
                
                Picker("", selection: $alertTime) {
                    ForEach(alertTimes, id:\.self) { time in
                        Text(alertTimeToString(alertTime: time))
                    }
                }
                .tint(.black)
            }
            
            Divider()
        }
        .padding(.vertical, 20)
    }
    
    @ViewBuilder // 시작 시간, 종료 시간 지정하는 뷰
    func dateView(title: String, date: Binding<Date>, focusDate: FocusComponent, focusTime: FocusComponent) -> some View {
        let isFocusDate = self.focusComponent == focusDate
        let isFocusTime = self.focusComponent == focusTime
        
        VStack {
            HStack(spacing: 5) {
                Text(title)
                
                Spacer()
                
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: width * 0.27, height: height * 0.04)
                    .foregroundStyle(isFocusDate ? .accent : .accent.opacity(0.15))
                    .overlay {
                        Text(dateToString(date: date.wrappedValue))
                            .font(.system(size: 16))
                            .foregroundStyle(isFocusDate ? .white : Color(uiColor: .systemGray3))
                    }
                    .onTapGesture {
                        self.focusField = nil
                        withAnimation {
                            if self.focusComponent == focusDate {
                                self.focusComponent = nil
                            } else {
                                self.focusComponent = focusDate
                            }
                        }
                    }
                
                if isAllDay == false {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: width * 0.27, height: height * 0.04)
                        .foregroundStyle(isFocusTime ? .accent : .accent.opacity(0.15))
                        .overlay {
                            Text(timeToString(date: date.wrappedValue))
                                .font(.system(size: 16))
                                .foregroundStyle(isFocusTime ? .white : Color(uiColor: .systemGray3))
                        }
                        .onTapGesture {
                            self.focusField = nil
                            withAnimation {
                                if self.focusComponent == focusTime {
                                    self.focusComponent = nil
                                } else {
                                    self.focusComponent = focusTime
                                }
                                
                            }
                        }
                }
            }
            
            // 달력이 나타나는 애니메이션을 위해 isFocusDate, isFocusTime 변수 대신 focusComponent 사용
            if self.focusComponent == focusDate {
                DatePicker("", selection: date, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .environment(\.locale, Locale(identifier: "ko"))
            } else if self.focusComponent == focusTime {
                DatePicker("", selection: date, displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.wheel)
                    .environment(\.locale, Locale(identifier: "ko"))
            }
        }
    }
    
    @ViewBuilder
    func MemoView() -> some View {
        VStack(alignment: .leading) {
            Text("메모")
                .font(.title2)
            
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color(uiColor: .systemGray6))
                    .frame(height: height * 0.25)
                    .onTapGesture {
                        focusField = .memo
                    }
                    .overlay {
                        VStack {
                            TextField("메모를 입력해주세요.", text: $memo, axis: .vertical)
                                .focused($focusField, equals: .memo)
                                .padding([.top, .leading], 10)
                                .onChange(of: memo) {
                                    memo = String(memo.prefix(300))
                                }
                            
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text("\(memo.count)")
                                    .foregroundStyle(memo.count == 300 ? .red : Color(uiColor:.systemGray2))
                                +
                                Text(" / 300")
                                    .foregroundStyle(Color(uiColor: .systemGray3))
                            }
                            .padding([.bottom, .trailing], 5)
                        }
                    }
            }
        }
    }
}
