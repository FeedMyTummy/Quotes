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
                ProgressView()
            case .failed(let error):
                Text("Error: \(error.localizedDescription)")
            case .loaded(let quote):
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
        .navigationBarHidden(true)
        .ignoresSafeArea()
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
