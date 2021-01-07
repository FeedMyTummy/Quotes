//
//  LocalQuotesService.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import Foundation

final class LocalQuotesService: QuotesService {
    
    func fetchQuote(completion: @escaping ((Result<Quote, Error>) -> Void)) {
        let decoder = JSONDecoder()
        let data = json.data(using: .utf8)!
        let quotes = try! decoder.decode([Quote].self, from: data)
        let quote = quotes.randomElement()!
        completion(.success(quote))
    }
    
    private let json = """
    [
      {
        "phrase": "Not your keys, not your bitcoin.",
        "author": "Andreas Antonopoulos"
      },
      {
        "phrase": "Imagine the entire world economy moving into bitcoin. Everything there is, divided by 21 million.",
        "author": "Knut Svanholm"
      }
    ]
    """
    
}
