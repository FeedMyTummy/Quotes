//
//  NotificationCenter.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/8/20.
//

import NotificationCenter

class NotificationCenter: NSObject, ObservableObject {
    
    @Published var dailyQuoteNotification = false
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension NotificationCenter: UNUserNotificationCenterDelegate  {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == LocalNotificationFactory().makeDailyQuote().id {
            dailyQuoteNotification.toggle()
        }
        
        completionHandler()
    }
    
}
