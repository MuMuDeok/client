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
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.context)
                .environmentObject(coordinator)
                .onAppear {
                    notificationManager.requestPermission()
                    notificationManager.registerDelegate()
                }
        }
    }
}
