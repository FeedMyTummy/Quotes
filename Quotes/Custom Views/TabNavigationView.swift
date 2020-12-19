//
//  TabNavigationView.swift
//  Quotes
//
//  Created by FeedMyTummy on 12/6/20.
//

import SwiftUI

struct TabNavigationView: View {
    
    enum Side {
        case left
        case right
    }
    
    let fontSize = CGFloat(35)
    let sidePadding = CGFloat(20)
    let topPadding = CGFloat(20)
    let bottomPadding = CGFloat(10)
    
    private let didTapToSwitch: () -> ()
    private let side: Side
    private let icon: Image
    
    var body: some View {
        VStack {
            HStack {
                if side == .right { Spacer() }
                
                Button(action: {
                    didTapToSwitch()
                }) {
                    icon
                        .renderingMode(.original)
                        .font(.system(size: fontSize))
                        .padding(side == .right ? .trailing : .leading, sidePadding)
                        .padding(.top, topPadding)
                        .padding(.bottom, bottomPadding)
                }
                
                if side == .left { Spacer() }
            }
        }
    }
    
    init(icon: Image, side: Side, _ didTapToSwitch: @escaping () -> ()) {
        self.icon = icon
        self.didTapToSwitch = didTapToSwitch
        self.side = side
    }
    
}

struct TabViewNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigationView(icon: Image(systemName: "gear"), side: .left, {})
    }
}
