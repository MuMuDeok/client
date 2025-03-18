//
//  NetworkMonitor.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/16/25.
//

import Network
import CoreData
import Foundation
import SwiftUI

@Observable
class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    private let persistenceController = PersistenceController.shared

    var isConnected: Bool = true
    private var wasConnected: Bool = true // 🔥 이전 네트워크 상태 저장

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                let status = path.status == .satisfied

                // 인터넷 연결된 경우 실행
                if status {
                    self.reTryApi()
                }

                self.isConnected = status
                self.wasConnected = status // 현재 상태를 저장
            }
        }
        monitor.start(queue: queue)
    }
    
    func reTryApi() {
        persistenceController.reTryFailedEvents()
    }
}
