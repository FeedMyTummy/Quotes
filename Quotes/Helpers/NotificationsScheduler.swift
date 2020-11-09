//
//  NotificationsScheduler.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/8/20.
//

import NotificationCenter

struct QuotesNotification {
    let id: String
    let title: String
    let body: String
    let sound: UNNotificationSound
    let timeInterval: TimeInterval
    let repeats: Bool
}

struct LocalNotificationFactory {
    
    func makeDailyQuote() -> QuotesNotification {
        
        let minute = 60.0
        let hour   = minute * 60.0
        let day    = hour * 24.0
        
        return QuotesNotification(id: "daily",
                                  title: "Daily Quote",
                                  body: "",
                                  sound: .default,
                                  timeInterval: 60,
                                  repeats: true)
    }
}

final class NotificationsScheduler {
    
    func schedule(_ notification: QuotesNotification) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestNotificationAuthorization(notification)
            case .denied:
                print("Notification authorization denied") // TODO:
            case .authorized:
                self.scheduleNotifications(notification)
            case .provisional, .ephemeral:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func doesNotificationExistWith(id: String, completion: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let doesExist = requests.contains(where: { $0.identifier == id })
            completion(doesExist)
        }
    }
    
    private func requestNotificationAuthorization(_ notification: QuotesNotification) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted && error == nil {
                self.scheduleNotifications(notification)
            }
        }
    }
    
    private func scheduleNotifications(_ notification: QuotesNotification) {
        doesNotificationExistWith(id: notification.id) { doesExist in
            guard !doesExist else { return }
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = notification.sound
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: notification.timeInterval,
                                                            repeats: notification.repeats)
            
            let request = UNNotificationRequest(identifier: notification.id,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
}
