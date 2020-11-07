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
            NavigationView {
                let quotesService = LocalQuotesService()
                let quotesViewModel = QuotesViewModel(service: quotesService)
                InitialView(quotesViewModel: quotesViewModel)
            }.preferredColorScheme(.light)
        }
    }
}

