//
//  Wallet+Observers.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 13.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletView {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewToTop), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewToBack), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideZoomedView), name: NSNotification.Name("criptolikeLongPressDidEnded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChanged), name:  Notification.Name("UIDeviceOrientationDidChangeNotification"), object: nil)
    }
    
    @objc func hideZoomedView(notification: NSNotification) {
        self.cryptoZoomView.hideAnimatedFreeformView()
    }
    
    @objc func orientationDidChanged(notification: NSNotification) {
        let deadlineTime = DispatchTime.now() + .seconds(0)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.refreshScrollViewContentSize()
        }
    }
}
