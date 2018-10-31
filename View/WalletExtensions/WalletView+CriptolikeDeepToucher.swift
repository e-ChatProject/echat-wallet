//
//  WalletView+CriptolikeDeepToucher.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 13.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletView {
    
    @objc func gestureRecognized(sender: CryptolikeDeepToucher) {
        switch sender.state {
            case UIGestureRecognizerState.began:        // usual tap
                if let touchedView = sender.view as? CLImageView {
                    if touchedView.image != nil {
                        let postIndexPath: IndexPath      = touchedView.indexPath!
                        let selectedValues: [String: Any] = self.transactionsArray[postIndexPath.section][postIndexPath.row]
                        
                        if selectedValues.count > 0 {
                            self.cryptoZoomView.setViewsValues(by: selectedValues)
                            self.cryptoZoomView.showAnimatedFreeformView()
                        }
                    }
                }
            default:
                break
        }
    }
    
    @objc func deepToucherRecognized(sender: CryptolikeDeepToucher) {
        if let touchedView = sender.view as? CLImageView {
            if touchedView.image != nil {
                echtViewDidTouched(touchedView)
            }
        }
    }
    
    @objc func longGestureRecognized(sender: UILongPressGestureRecognizer) {
        if (sender.state == .ended) {
            if let touchedView = sender.view as? CLImageView {
                if touchedView.image != nil {
                    echtViewDidTouched(touchedView)
                }
            }
        }
        
    }
    
    func echtViewDidTouched(_ touchedView: CLImageView) {
        let selectedIndex  = touchedView.indexPath
        let selectedValues = self.transactionsArray[(selectedIndex?.section)!][(selectedIndex?.row)!]
        
        if let dynamicId = selectedValues["dynamicid"] as? String {
            if !dynamicId.isEmpty {
                self.presenter?.interactor?.loadCryptolikePostDetails(by: dynamicId)
            }
        }
    }

}
