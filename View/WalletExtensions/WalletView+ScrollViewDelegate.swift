//
//  WalletView+ScrollViewDelegate.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 06.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.transactionsTableView.contentOffset.y == 0.0 {

        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / UIScreen.main.bounds.size.width)
        self.pageControl.currentPage = Int(pageNumber)
        
        changePageTitle(by: self.pageControl.currentPage)
        
        let hideKeyboardViews: [UIView] = [self.balanceView, self.sendReceiptView, self.withdrawView, self.receiveView]
        
        for childView in hideKeyboardViews {
            childView.endEditing(true)
        }
        
        if self.pageControl.currentPage == 0 || self.sendView.isHidden == true {
            self.sendView.hideKeyboard()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.isDecelerating == false {
            
        }
    }
}
