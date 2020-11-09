//
//  QuoteBubbleView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct QuoteBubbleView: View {
    let quote: Quote
    
    var body: some View {
        VStack(spacing: phraseAndAuthorVerticalSpacing) {
            Text("\"\(quote.phrase)\"").font(.title).padding([.horizontal, .top])
            Text("- \(quote.author)").padding([.horizontal, .bottom])
        }
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(bubbleCornerRadius)
        .shadow(color: Color.black.opacity(shadowOpacity), radius: shadowCornerRadius)
    }
    
    init(_ quote: Quote) {
        self.quote = quote
    }
    
    // MARK: - Constants
    private let phraseAndAuthorVerticalSpacing: CGFloat = 25
    private let bubbleCornerRadius: CGFloat = 25
    private let shadowCornerRadius: CGFloat = 10
    private let shadowOpacity: Double = 0.6
}

struct QuoteBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteBubbleView(Quote(phrase: "21,000,000", author: "My Node"))
    }
}
