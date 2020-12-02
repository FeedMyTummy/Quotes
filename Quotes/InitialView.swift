//
//  InitialView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct InitialView: View {
    
    @ObservedObject private var quotesViewModel: QuotesViewModel
    
    var body: some View {
        ZStack {
            Color.orange
            switch quotesViewModel.state {
            case .idle, .loading:
                makeProgressView()
            case .failed(let error):
                makeErrorView(error)
            case .loaded(let quote):
                QuoteView(quote)
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
    
    init(quotesViewModel: QuotesViewModel) {
        self.quotesViewModel = quotesViewModel
    }
    
    private func makeProgressView() -> some View {
        ProgressView()
    }
    
    private func makeErrorView(_ error: Error) -> some View {
        Text("Error: \(error.localizedDescription)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let quotesViewModel = QuotesViewModel(service: LocalQuotesService())
        let initialView = InitialView(quotesViewModel: quotesViewModel)
        quotesViewModel.fetchQuote()
        return initialView
    }
}
