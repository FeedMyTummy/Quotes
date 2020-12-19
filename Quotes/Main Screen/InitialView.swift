//
//  InitialView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct InitialView: View {
    
    @ObservedObject private var quotesViewModel: QuotesViewModel
    @ObservedObject private var tabSelected: SelectedTab
    
    var body: some View {
        ZStack {
            Color.orange
            
            VStack {
                TabViewNavigationView(icon: Image(systemName: "gear"), side: .right) {
                    tabSelected.selection = .settings
                }
                
                Spacer()
                
                switch quotesViewModel.state {
                case .idle, .loading:
                    makeProgressView()
                case .failed(let error):
                    makeErrorView(error)
                case .loaded(let quote):
                    QuoteView(quote)
                }
                
                Spacer()
                Spacer()
            }
        }
    }
    
    init(quotesViewModel: QuotesViewModel, selection: SelectedTab) {
        self.quotesViewModel = quotesViewModel
        self.tabSelected = selection
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
        let initialView = InitialView(quotesViewModel: quotesViewModel, selection: .init())
        quotesViewModel.fetchQuote()
        return initialView
    }
}
