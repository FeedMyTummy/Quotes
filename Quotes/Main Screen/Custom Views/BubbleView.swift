//
//  BubbleView.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/6/20.
//

import SwiftUI

struct BubbleView<Content: View>: View {
    
    private let content: () -> Content
    
    var body: some View {
        VStack(spacing: phraseAndAuthorVerticalSpacing) {
            content()
        }
        .cornerRadius(bubbleCornerRadius)
        .shadow(color: Color.black.opacity(shadowOpacity), radius: shadowCornerRadius)
    }
    
    init(_ content: @escaping () -> Content) {
        self.content = content
    }
    
    // MARK: - Constants
    private let phraseAndAuthorVerticalSpacing: CGFloat = 25
    private let bubbleCornerRadius: CGFloat = 25
    private let shadowCornerRadius: CGFloat = 10
    private let shadowOpacity: Double = 0.6
}

struct BubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle().foregroundColor(.orange).edgesIgnoringSafeArea(.all)
            BubbleView {
                QuoteView(Quote(phrase: "21,000,000", author: "My Node"))
            }
        }
    }
}
