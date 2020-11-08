//
//  InitialView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct InitialView: View {
    
    @ObservedObject private var quotesViewModel: QuotesViewModel
    @ObservedObject private var foregroundObserver: ForegroundObserver
    
    var body: some View {
        ZStack {
            Color.white
            switch quotesViewModel.state {
            case .idle, .loading:
                ProgressView()
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
        .onReceive(foregroundObserver.$enteredForeground) { _ in
            quotesViewModel.fetchQuote()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
    
    init(quotesViewModel: QuotesViewModel, foregroundObserver: ForegroundObserver) {
        self.quotesViewModel = quotesViewModel
        self.foregroundObserver = foregroundObserver
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(quotesViewModel: QuotesViewModel(service: LocalQuotesService()), foregroundObserver: .init())
    }
}
