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
    var event: PersonalEvent {
        self.eventDetailVM.fetchEvent(id: self.id) as! PersonalEvent
    }
    @State var isEditing: Bool = false
    
    init(event: PersonalEvent) {
        self.id = event.id
    }
    
    var body: some View {
        VStack {
            eventHeaderView()
            
            Spacer()
        }
        .sheet(isPresented: self.$isEditing, content: {
            EditPersonalEventView(eventDetailVM: eventDetailVM, event: event)
        })
        .navigationBarBackButtonHidden()
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

extension PersonalEventDetailView {
    @ViewBuilder
    func eventHeaderView() -> some View {
        let date = eventDetailVM.convertEventDateToString(event: event)
        let time = eventDetailVM.convertEventTimeToString(event: event)
        
        VStack(alignment: .leading, spacing: 15) {
            Text(event.title)
                .font(.title2)
                .padding(.horizontal, 10)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color(.systemGray6))
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.1)
                
                VStack(spacing: 10) {
                    HStack {
                        Text("날짜  \(date)")
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("시간  \(time)")
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 10)
                .frame(width: UIScreen.main.bounds.width * 0.95 - 20)
                
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 15)
    }
}
