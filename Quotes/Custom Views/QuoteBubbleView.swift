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
        VStack(spacing: 20) {
            Text("\"\(quote.phrase)\"").font(.title).padding([.horizontal, .top])
            Text("- \(quote.author)").padding([.horizontal, .bottom])
        }
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.6),
                radius: 20)
    }
    
    init(_ quote: Quote) {
        self.quote = quote
    }
}

struct QuoteBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteBubbleView(Quote(phrase: "21,000,000", author: "My Node"))
    }
}
