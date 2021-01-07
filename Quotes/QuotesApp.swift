//
//  QuotesApp.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

enum TabName: Hashable {
    case home
    case settings
}

class SelectedTab: ObservableObject {
    @Published var selection = TabName.home
}

@main
struct QuotesApp: App {
    
    @StateObject private var tabSelected = SelectedTab()
    @StateObject private var quotesViewModel = QuotesViewModel(service: LocalQuotesService())
    
    @AppStorage("firstLaunch") var firstLaunch = true
    
    private let tabAnimationDuration = 1.0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $tabSelected.selection) {
                InitialView(quotesViewModel: quotesViewModel, selection: tabSelected)
                    .tag(TabName.home)
                SettingsView(selection: tabSelected)
                    .tag(TabName.settings)
            }
            .animation(.easeOut(duration: tabAnimationDuration))
            .tabViewStyle(PageTabViewStyle())
            .onAppear {
                if firstLaunch {
                    let notification = LocalNotificationFactory().makeDaily(startDate: Date())
                    NotificationsScheduler().schedule(notification) { _ in
                        firstLaunch = false
                    }
                }
                
                quotesViewModel.fetchQuote()
            }
        }
    }
}
