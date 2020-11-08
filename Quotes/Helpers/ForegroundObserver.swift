//
//  ForegroundObserver.swift
//  Quotes
//
//  Created by FeedMyTummy on 11/7/20.
//

import Foundation
import UIKit.UIApplication

class ForegroundObserver: ObservableObject {

    @Published var enteredForeground = true

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func willEnterForeground() {
        enteredForeground.toggle()
    }
}
