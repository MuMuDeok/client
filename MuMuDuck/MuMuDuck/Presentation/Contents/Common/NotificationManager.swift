//
//  NotoficationManager.swift
//  MuMuDuck
//
//  Created by 강승우 on 3/13/25.
//

import SwiftUI

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()
    
    private override init() {}

    // 알림 권한 요청
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ 알림 권한 요청 실패: \(error)")
            } else {
                print("✅ 알림 권한 승인 여부: \(granted)")
            }
        }
    }

    // 이벤트 알림 추가하기
    func addEventAlert(event: any Event) {
        // nil인 경우 알림이 없으므로 함수 종료
        guard let alertTime = event.alertTime else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "MuMuDuck"
        content.body =
        """
        \(event.title)
        \(getAlertBody(alertTime: alertTime))
        """
       
        content.sound = .default

        let calendar = Calendar.current
        guard let triggerDate = calendar.date(byAdding: .minute, value: -alertTime, to: event.startDate) else {
            return
        }
            
        let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 추가 실패: \(error)")
            } else {
                print("알림이 예약됨")
            }
        }
    }
    
    // 포그라운드에서도 알림 표시 (필수)
    func registerDelegate() {
        UNUserNotificationCenter.current().delegate = self
    }

    // 포그라운드에서도 알림이 보이도록 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    // 알림의 body에 들어갈 내용
    func getAlertBody(alertTime: Int) -> String {
        if alertTime == 0 {
            return "지금"
        } else if alertTime < 60 {
            return "\(alertTime)분 전"
        } else {
            return "\(alertTime/60)시간 전"
        }
    }
}

