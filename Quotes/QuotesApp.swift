//
//  QuotesApp.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

@main
struct QuotesApp: App {
    
    var body: some Scene {
        WindowGroup {
            let quotesService = LocalQuotesService()
            let quotesViewModel = QuotesViewModel(service: quotesService)
            NavigationView {
                InitialView(quotesViewModel: quotesViewModel)
            }
            .preferredColorScheme(.light)
            .onAppear {
                let notification = LocalNotificationFactory().makeDailyQuote()
                NotificationsScheduler().schedule(notification)
            }
            .onAppear {
                quotesViewModel.fetchQuote()
            }
        }
    }
}
