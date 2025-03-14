//
//  MuMuDuckApp.swift
//  MuMuDuck
//
//  Created by 강승우 on 2/5/25.
//

import SwiftUI

@main
struct MuMuDuckApp: App {
    @StateObject var coordinator: Coordinator = Coordinator()
    let notificationManager: NotificationManager = NotificationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
                .onAppear {
                    notificationManager.requestPermission()
                    notificationManager.registerDelegate()
                }
        }
    }
}
