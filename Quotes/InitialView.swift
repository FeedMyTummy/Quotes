//
//  InitialView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct InitialView: View {
    
    @ObservedObject private var quotesViewModel: QuotesViewModel
    @State private var animate = false
    
    var body: some View {
        ZStack {
            Color.white
            switch quotesViewModel.state {
            case .idle, .loading:
                makeProgressView()
            case .failed(let error):
                makeErrorView(error)
            case .loaded(let quote):
                makeQuoteView(quote)
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
    
    private func makeQuoteView(_ quote: Quote) -> some View {
        VStack {
            Spacer()
            QuoteBubbleView(quote)
                .padding([.horizontal], 20)
                .scaleEffect(animate ? 1 : 0.5)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        animate.toggle()
                    }
                }
            Spacer()
            Spacer()
        }
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
