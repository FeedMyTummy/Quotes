//
//  LocalQuotesService.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import Foundation

final class LocalQuotesService: QuotesService {
    
    func fetchQuote(completion: @escaping ((Result<Quote, Error>) -> Void)) {
        let quotes: [Quote] = Bundle.main.decode("quotes.json")
        let quote = quotes.randomElement()!
        
        completion(.success(quote))
    }
}
