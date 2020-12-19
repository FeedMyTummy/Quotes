//
//  QuotesService.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import Foundation

protocol QuotesService {
    func fetchQuote(completion: @escaping ((Result<Quote, Error>) -> Void))
}

