//
//  QuoteView.swift
//  Quotes
//
//  Created by FeedMyTummy on 12/2/20.
//

import SwiftUI

struct QuoteView: View {
    
    @State private var animate = false
    private let quote: Quote
    
    var body: some View {
        VStack {
            Spacer()
            BubbleView {
                VStack {
                    Text("\"\(quote.phrase)\"").font(.title).padding([.horizontal, .top])
                    Text("- \(quote.author)").padding([.horizontal, .bottom])
                }
                .background(Color.white)
            }
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
    
    init(_ quote: Quote) {
        self.quote = quote
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.orange.edgesIgnoringSafeArea(.all)
            QuoteView(Quote(phrase: "21,000,000", author: "My Node"))
        }
    }
}
