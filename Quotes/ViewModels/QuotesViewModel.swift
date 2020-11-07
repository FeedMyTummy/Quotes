//
//  QuotesViewModel.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import Foundation

class QuotesViewModel: ObservableObject {
    
    enum State {
        case idle
        case loading
        case failed(Error)
        case loaded(Quote)
    }
    
    private let service: QuotesService
    @Published private(set) var state = State.idle
    
    init(service: QuotesService) {
        self.service = service
    }
    
    func fetchQuote() {
        state = .loading
        
        service.fetchQuote { result in
            switch result {
            case .success(let quote):
                self.state = .loaded(quote)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
