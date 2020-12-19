//
//  NotificationSettings.swift
//  Quotes
//
//  Created by FeedMyTummy on 12/6/20.
//

import Foundation

struct HourMinute: Equatable {
    let hour: Int
    let minute: Int
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    init(date: Date) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        hour = components.hour!
        minute = components.minute!
    }
    
    func toDate() -> Date {
        DateComponents(calendar: Calendar.current,
                       timeZone: TimeZone.current,
                       hour: hour,
                       minute: minute).date!
    }
}

class NotificationSettings: ObservableObject {
    
    enum State: Equatable {
        case idle
        case loading
        case dailyNotificationTime(HourMinute)
        case disabled
        case failed
    }
    
    @Published private(set) var dailyNotificationTime: State = .idle
    
    private var isFetching = false
    
    init() {
        loadDailyNotificationDate()
    }
    
    func rescheduleDailyNotificationWith(date: Date, completion: @escaping (Result<Void, NotificationsSchedulerError>) -> ()) {
        let dailyNotification = LocalNotificationFactory().makeDaily(startDate: date)
        
        NotificationsScheduler().reschedule(dailyNotification) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.dailyNotificationTime = .dailyNotificationTime(HourMinute(date: date))
                case .failure:
                    self.dailyNotificationTime = .failed
                }
                completion(result)
            }
        }
    }
    
    func removeDailyNotification() {
        NotificationsScheduler().removeNotificationWith(ids: [LocalNotificationFactory.dailyNotificationID])
        dailyNotificationTime = .disabled
    }
    
     func loadDailyNotificationDate() {
        guard !isFetching else { return }
        isFetching = true
        
        dailyNotificationTime = .loading
        NotificationsScheduler().dateForNotificationWith(id: LocalNotificationFactory.dailyNotificationID) { [weak self] date in
            guard let self = self else { return }
            if let date = date {
                self.dailyNotificationTime = .dailyNotificationTime(HourMinute(date: date))
            } else {
                self.dailyNotificationTime = .disabled
            }
            self.isFetching = false
        }
    }
}
