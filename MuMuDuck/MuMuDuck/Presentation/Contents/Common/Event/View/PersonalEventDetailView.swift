//
//  PersonalEventDetailView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/15/25.
//

import SwiftUI

struct PersonalEventDetailView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let eventDetailVM: EventDetailViewModel = EventDetailViewModel()
    let id: UUID
    var event: PersonalEvent { // 편집했을 때 일정 디테일뷰가 변하기 위해 연산 프로퍼티로 변경
        self.eventDetailVM.fetchEvent(id: self.id) as! PersonalEvent
    }
    @State var isEditing: Bool = false
    @State var isShowingAlert: Bool = false
    @State var isShowingMemo: Bool = false
    
    init(event: PersonalEvent) {
        self.id = event.id
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 20) {
                // 이벤트 제목
                Text(event.title)
                    .font(.system(size: 20))
                    .padding(.vertical, 10)
                
                // 이벤트 시간
                HStack {
                    timeView(time: event.startDate)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.accent)
                        .frame(width: 24, height: 24)
                    
                    timeView(time: event.endDate)
                }
                
                Divider()
                
                // 이벤트 알림
                HStack(spacing: 10) {
                    Image("alert_Icon")
                        .frame(width: 16, height: 16)
                    
                    HStack {
                        Text("알림")
                        
                        Spacer()
                        
                        Text(eventDetailVM.convertEventAlertToString(time: event.alertTime))
                    }
                }
                
                Divider()
                
                HStack(spacing: 10) {
                    Image("memo_Icon")
                        .frame(width: 16, height: 16)
                    
                    HStack {
                        Text("메모")
                        
                        Spacer()
                        
                        Button {
                            isShowingMemo.toggle()
                        } label: {
                            Image(systemName: isShowingMemo ? "chevron.up" : "chevron.down")
                        }
                    }
                }
                
                if isShowingMemo {
                    Text(event.memo)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
                
            dividerAndDeleteButtonView()
        }
        .sheet(isPresented: self.$isEditing, content: {
            EditPersonalEventView(eventDetailVM: eventDetailVM, event: event)
        })
        .alert("정말로 삭제하겠습니까?", isPresented: self.$isShowingAlert) {
            Button("취소", role: .cancel) {
                isShowingAlert = false
            }
            
            Button("삭제", role: .destructive) {
                coordinator.pop()
                
                // event를 바로 삭제할 경우 에러가 발생함
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    eventDetailVM.deleteEvent(event: event)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    coordinator.pop()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    self.isEditing = true
                } label: {
                    Text("편집")
                }
            }
        }
    }
}

private extension PersonalEventDetailView {
    @ViewBuilder
    func timeView(time: Date) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(.accent, lineWidth: 1)
            .overlay {
                VStack(spacing: 7) {
                    Text(eventDetailVM.convertEventDateToString(time: time))
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                    
                    Text(eventDetailVM.convertEventTimeToString(time: time))
                        .font(.system(size: 24))
                }
            }
            .frame(height: 74)
    }
    
    @ViewBuilder
    func dividerAndDeleteButtonView() -> some View {
        VStack {
            Divider()
            
            Spacer()
            
            Button {
                self.isShowingAlert = true
            } label: {
                Rectangle()
                    .foregroundStyle(.white)
                    .overlay {
                        Text("일정 삭제")
                            .font(.system(size: 18))
                    }
            }
            .frame(height: 50)
        }
    }
}
