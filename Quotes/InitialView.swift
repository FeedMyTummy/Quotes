//
//  InitialView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct InitialView: View {
    
    @ObservedObject private var quotesViewModel: QuotesViewModel
    @StateObject private var notificationCenter = NotificationCenter()
    
    var body: some View {
        ZStack {
            Color.white
            switch quotesViewModel.state {
            case .idle, .loading:
                ProgressView().onAppear(perform: quotesViewModel.fetchQuote)
            case .failed(let error):
                Text("Error: \(error.localizedDescription)")
            case .loaded(let quote):
                VStack {
                    Spacer()
                    QuoteBubbleView(quote).padding([.horizontal], 20)
                    Spacer()
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onChange(of: notificationCenter.dailyQuoteNotification) { _ in
            quotesViewModel.fetchQuote()
        }
    }
    
    init(quotesViewModel: QuotesViewModel) {
        self.quotesViewModel = quotesViewModel
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(quotesViewModel: QuotesViewModel(service: LocalQuotesService()))
    }
}
