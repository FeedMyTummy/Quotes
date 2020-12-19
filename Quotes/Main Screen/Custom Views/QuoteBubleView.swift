//
//  QuoteBubleView.swift
//  Quotes
//
//  Created by FeedMyTummy on 12/2/20.
//

import SwiftUI

struct QuoteBubleView: View {
    
    @State private var isFirstTimeAppearing = true
    
    private let quote: Quote
    
    // MARK: Constants
    private let initialScaleFactor: CGFloat = 0.5
    private let finalScaleFactor: CGFloat   = 1.0
    private let horizontalPadding: CGFloat  = 20.0
    private let animationDelay              = 0.05
    private let animationDuration           = 0.3
    
    var body: some View {
        BubbleView {
            VStack {
                Text("\"\(quote.phrase)\"")
                    .font(.title)
                    .padding([.horizontal, .vertical])
                    .foregroundColor(.black)
                Text("- \(quote.author)")
                    .padding([.horizontal, .bottom])
                    .foregroundColor(.black)
            }
            .background(Color.white)
        }
        .padding([.horizontal], horizontalPadding)
        .scaleEffect(isFirstTimeAppearing ? initialScaleFactor : finalScaleFactor)
        .onAppear {
            guard isFirstTimeAppearing else { return }
            isFirstTimeAppearing = false
        }
        .animation(
            Animation.easeOut(duration: animationDuration)
                     .delay(animationDelay)
        )
    }
    
    init(_ quote: Quote) {
        self.quote = quote
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.orange.edgesIgnoringSafeArea(.all)
            QuoteBubleView(Quote(phrase: "21,000,000", author: "My Node"))
        }
    }
}
