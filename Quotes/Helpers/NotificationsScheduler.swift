//
//  NotificationsScheduler.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/8/20.
//

import NotificationCenter
import SwiftUI

struct QuotesNotification {
    
    enum Repeat {
        case doesNotRepeat
        case daily
    }
    
    let id: String
    let title: String
    let body: String
    let sound: UNNotificationSound
    let startDate: Date
    let frequency: Repeat
}

struct LocalNotificationFactory {
    
    static let dailyNotificationID = "daily"
    
    func makeDaily(startDate: Date) -> QuotesNotification {
        return QuotesNotification(id: LocalNotificationFactory.dailyNotificationID,
                                  title: "Daily Quote",
                                  body: "",
                                  sound: .default,
                                  startDate: startDate,
                                  frequency: .daily)
    }
}


enum NotificationsSchedulerError: Error {
    case authorizationDenied
    case uknown
}

// All strong self references are intentional. These ensures NotificationsScheduler is kept on the heap until method finishes.
final class NotificationsScheduler {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let currentCalendar = Calendar.current
    
    func schedule(_ notification: QuotesNotification, _ completion: @escaping ((Result<Void, NotificationsSchedulerError>) -> ())) {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestPermission { granted in
                    if granted {
                        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.3) {
                            self.scheduleNotification(notification)
                            completion(.success(()))
                        }
                    } else {
                        completion(.failure(.authorizationDenied))
                    }
                }
            case .denied:
                completion(.failure(.authorizationDenied))
            case .authorized:
                self.scheduleNotification(notification)
                completion(.success(()))
            case .provisional, .ephemeral:
                // TODO:
                break
            @unknown default:
                completion(.failure(.uknown))
                break
            }
        }
    }
    
    func reschedule(_ notification: QuotesNotification, completion: @escaping (Result<Void, NotificationsSchedulerError>) -> ()) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notification.id])
        
        schedule(notification) { result in
            switch result {
            case .success:
                self.schedule(notification) { result in
                    switch result {
                    case .success():
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeNotificationWith(ids: [String]) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    func dateForNotificationWith(id: String, completion: @escaping (Date?) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            
            var date: Date? = nil
            
            if let notification = requests.first(where: { $0.identifier == id })?.trigger as? UNCalendarNotificationTrigger {
                date = self.currentCalendar.date(from: notification.dateComponents)
            }
            
            DispatchQueue.main.async {
                completion(date)
            }
        }
    }
    
    private func doesNotificationExistWith(id: String, completion: @escaping (Bool) -> ()) {
        notificationCenter.getPendingNotificationRequests { requests in
            let doesExist = requests.contains(where: { $0.identifier == id })
            completion(doesExist)
        }
    }
    
    private func requestPermission(completion: @escaping (Bool) -> ()) {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            completion(granted && error == nil)
        }
    }
    
    private func scheduleNotification(_ notification: QuotesNotification) {
        doesNotificationExistWith(id: notification.id) { doesNotificationExist in
            guard !doesNotificationExist else { return }
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.body
            content.sound = notification.sound
            
            let trigger: UNCalendarNotificationTrigger
            
            switch notification.frequency {
            case .doesNotRepeat:
                let triggerDate = self.currentCalendar.dateComponents([.year, .month, .day, .hour, .minute], from: notification.startDate)
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            case .daily:
                let triggerDaily = self.currentCalendar.dateComponents([.hour, .minute], from: notification.startDate.addingTimeInterval(10))
                trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
            }
            
            let request = UNNotificationRequest(identifier: notification.id,
                                                content: content,
                                                trigger: trigger)
            
            self.notificationCenter.add(request)
        }
    }
    
}
