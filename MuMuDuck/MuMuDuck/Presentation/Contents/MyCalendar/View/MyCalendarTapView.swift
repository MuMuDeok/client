//
//  MyCalendarTapView.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/11/25.
//

import SwiftUI

struct MyCalendarTapView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Text("내 캘린더")
        }
        .navigationTitle("내 캘린더")
    }
}
