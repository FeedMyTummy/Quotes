//
//  LocalQuotesService.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import Foundation

final class LocalQuotesService: QuotesService {
    
    func fetchQuote(completion: @escaping ((Result<Quote, Error>) -> Void)) {
        let quote = quotes.randomElement()!
        completion(.success(quote))
    }
    
    private let quotes = [
        Quote(phrase: "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks",
              author: "Satoshi Nakamoto"),
        
        Quote(phrase: "Not your keys, not your Bitcoin",
              author: "Andreas Antonopoulos"),
        
        Quote(phrase: "Imagine the entire world economy moving into bitcoin. Everything there is, divided by 21 million.",
              author: "Knut Svanholm")
    ]
    
}
