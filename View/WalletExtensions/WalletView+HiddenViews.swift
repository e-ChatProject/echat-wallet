//
//  WalletView+HiddenViews.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView {
    
    func addHiddenFreeformViews(_ views: [UIView]) {
        for childView in views {
            let childValues = ["childView": childView]
            let horizChildFormat   = "H:|-(10)-[childView]-(10)-|"

            addConstraints(for:childValues, with:[horizChildFormat], to:self.view)

            let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat:"V:[childView(100)]", metrics: nil, views: childValues)
            self.view.addConstraints(heightConstraints)
            
            if let hiddenView = childView as? ZoomedView {
                hiddenView.heightConstraint = heightConstraints.last        // Store height for change in future
            }
            
            self.view.addCenterY(to: self.view, for: childView)

            childView.isHidden = true
        }
        
    }
    
    func addHiddenChildViews(_ views: [UIView]) {
        for childView in views {
            let childValues = ["childView": childView]
            let horizChildFormat   = String.init(format:"H:|[childView]|")
            let vertChildFormat    = String.init(format:"V:|[childView]|")
            
            let childViewFormats = [horizChildFormat, vertChildFormat]
            addConstraints(for:childValues, with:childViewFormats, to:self.containerView)
            
            childView.isHidden = true
        }
        
    }
    
    func showHiddedView(_ view: UIView) {
        view.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       options: .transitionCrossDissolve,
                       animations: {
                        view.isHidden   = false
                        
                        self.setPageControlVisibility(by: view)
                        
                        view.alpha      = 1
        }, completion: { finished in
            self.scrollView.isHidden    = true
        })
    }
    
    func hideHiddenView(_ view: UIView) {
        view.alpha = 1
        
        if view == self.sendReceiptView {
            self.pageControl.isHidden       = false
            self.pageControl.currentPage    = 1
        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       options: .transitionCrossDissolve,
                       animations: {
                        view.alpha                = 0
                        
                        self.scrollView.isHidden  = false
        }, completion: { finished in
            view.isHidden   = true
        })
    }
    
    func showBalanceView(_ view: UIView) {
        view.alpha = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       options: .transitionCrossDissolve,
                       animations: {
                        view.isHidden   = false
                        
                        view.alpha      = 1
        }, completion: { finished in
            self.scrollView.isHidden        = false
        })
    }
    
    func addConstraints(for views:[String: UIView], with formats:[String], to parent:UIView) {
        var childView: UIView = UIView()
        
        for key in views.keys {
            childView = views[key]!
        }
        
        parent.addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        
        for format in formats {
            let constraint = NSLayoutConstraint.constraints(withVisualFormat:
                format, metrics: nil, views: views)
            parent.addConstraints(constraint)
        }
    }
    
    func setPageControlVisibility(by view: UIView) {
        self.pageControl.isHidden   = false
        if view == self.receiveView || view == self.sendReceiptView || view == self.withdrawView {
            self.pageControl.isHidden = true
        }
    }
    
    func updateUserFinanceInfo() {
        self.presenter?.interactor?.loadUserProfile()
    }
    
    func checkNetworkConnection() -> Bool {
        let isConnectionAvailable = WocaiNetworkClient().isNetworkReachable()
        if !isConnectionAvailable {
            showMessage("Slow or no internet connections.\nPlease check your internet settings".localized(using: "MessagesLocalizable"), with:EmptySendMoneyFieldsTypes.connectionError.rawValue)
            return false
        }
        
        return true
    }
    
    func goBackWithUpdate() {
        for hiddenView in self.hiddenChildViews {
            if hiddenView.isHidden == false {
                hideHiddenView(hiddenView)
                
                updateUserFinanceInfo()
            }
        }
    }
}
