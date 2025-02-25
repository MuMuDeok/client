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
    @FocusState private var focusField: FocusField?
    @State private var focusComponent: FocusComponent?
    
    let width: CGFloat = UIScreen.main.bounds.width
    let height: CGFloat = UIScreen.main.bounds.height
    
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
            
            ScrollView {
                TitleView()
                
                EventOptionSettingView()
                
                MemoView()
                
                Spacer()
            }
            .scrollDisabled(focusComponent == nil)
            .scrollIndicators(.hidden)
        }
        .padding(.horizontal, 15)
        .onAppear {
            self.focusField = .title
        }
    }
}

private extension CreateEventView {
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
}

private extension CreateEventView {
    @ViewBuilder
    func ToorbarView() -> some View {
        HStack {
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
            
            Toggle("알림설정", isOn: $isAlert)
                .tint(.accent)
                .padding(.trailing, 1.5)
            
            Divider()
        }
        .font(.title3)
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
                
                TextField("메모를 입력해주세요.", text: $memo, axis: .vertical)
                    .focused($focusField, equals: .memo)
                    .padding([.top, .leading], 10)
            }
        }
    }
}
