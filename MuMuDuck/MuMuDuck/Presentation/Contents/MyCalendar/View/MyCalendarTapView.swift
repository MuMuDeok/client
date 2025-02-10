//
//  MyCalendarTapView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import SwiftUI

struct MyCalendarTapView: View {
    @EnvironmentObject var coordinator: Coordinator
    let myCalendarVM: MyCalendarTapViewModel
    
    init() {
        self.myCalendarVM = MyCalendarTapViewModel()
    }
    
    var body: some View {
        VStack {
            Divider()
            
            if myCalendarVM.isCalendarOutspread() { // 달력 펼친 상태
                
                toggleOutspreadButton()
                
                
                Spacer()
            } else { // 달력 접힌 상태
                MiniCalendarView()
                
                toggleOutspreadButton()
                
                Spacer()
            }
        }
        .navigationTitle("내 캘린더")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

extension MyCalendarTapView {
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
}
