//
//  QuotesViewModel.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

class QuotesViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded(Quote)
    }
    
    private let service: QuotesService
    @Published private(set) var state = State.idle
    @AppStorage("firstQuoteFetch") private var firstQuoteFetch = true
    
    init(service: QuotesService) {
        self.service = service
    }
    
    func fetchQuote() {
        state = .loading
        
        if firstQuoteFetch {
            let quote = Quote(phrase: "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks",
                              author: "Satoshi Nakamoto")
            state = .loaded(quote)
            firstQuoteFetch = false
        } else {
            service.fetchQuote { [weak self] result in
                switch result {
                case .success(let quote):
                    self?.state = .loaded(quote)
                case .failure(let error):
                    self?.state = .failed(error)
                }
            }
        }
    }
}
