//
//  WalletView+UICustomizations.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView {
    
    func addCustomUI() {
        self.view.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.0)

        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width * 2, height: 1)
        
        addCustomViews()
        
        self.balanceLabel.textColor     = .white
        self.balanceLabel.textAlignment = .center
        self.balanceLabel.font          = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.light)

        setContentForScrollView()
        
        let balanceView = ["balanceLabel": self.balanceLabel]
        let balanceFormats = ["H:|[balanceLabel]|", "V:[balanceLabel(40)]"]
        addConstraints(for:balanceView, with:balanceFormats, to:self.topImageView)
        
        let pageView = ["pageControl": self.pageControl]
        
        var pagebottomMargin: Int = 30
        
        switch UIDevice.current.userInterfaceIdiom {
            case .pad:
                pagebottomMargin = 60
            default:
                break
        }
        
        let pageVertFormat = String.init(format: "V:[pageControl(5)]-(%d)-|", pagebottomMargin)
        let pageFormats = ["H:[pageControl(10)]",  pageVertFormat]
        addConstraints(for:pageView, with:pageFormats, to:self.topImageView)
        
        let pageXcenter = NSLayoutConstraint(item: self.pageControl, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.topImageView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let balanceYcenter = NSLayoutConstraint(item: self.balanceLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.topImageView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        
        self.topImageView.addConstraints([pageXcenter, balanceYcenter])
        
        self.pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for:.valueChanged)
        self.pageControl.pageIndicatorTintColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:0.5)
        self.pageControl.currentPageIndicatorTintColor = .white
        self.pageControl.numberOfPages = 2
        
        self.transactionsTableView                  = UITableView.init(frame: .zero, style: .grouped)
        self.transactionsTableView.delegate         = self
        self.transactionsTableView.dataSource       = self
        self.transactionsTableView.separatorStyle   = .none
        self.transactionsTableView.tableFooterView  = UIView()
        self.transactionsTableView.showsVerticalScrollIndicator     = false
        self.transactionsTableView.showsHorizontalScrollIndicator   = false
        
        let bgTableView = UIView()
        bgTableView.backgroundColor = .clear
        self.transactionsTableView.backgroundView   = bgTableView
        self.transactionsTableView.backgroundColor  = .clear
        
        self.balanceView.transactionsView.addSubview(self.transactionsTableView)
        self.transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let transacTableView: [String: UITableView] = ["transacTableView": self.transactionsTableView]
        let horizConstraint = NSLayoutConstraint.constraints(withVisualFormat:
            "H:|[transacTableView]|", metrics: nil, views: transacTableView)
        let vertConstraint = NSLayoutConstraint.constraints(withVisualFormat:
            "V:|[transacTableView]|", metrics: nil, views: transacTableView)
        self.balanceView.transactionsView.addConstraints(horizConstraint + vertConstraint)
        self.transactionsTableView.isHidden = true
        
        self.refreshControl.add(to: self.transactionsTableView, target: self, selector: #selector(self.refreshControlAction))
        self.refreshControl.loadingSpinner.colorSequence = [UIColor.init(hex: "58A0FF")]
        self.refreshControl.loadingSpinner.backgroundRailColor = UIColor(hex: "1E7AF4").withAlphaComponent(0.15)
        self.refreshControl.loadingSpinner.lineWidth = 3
        self.refreshControl.loadingSpinner.minimumArcLength = .pi/6
        self.refreshControl.loadingSpinner.maximumArcLength = (2 * .pi) - .pi/4
        
        let rightSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.topViewSwiped))
        rightSwipeGesture.direction = .right
        self.view.addGestureRecognizer(rightSwipeGesture)
        
        let leftSwipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.topViewSwiped))
        leftSwipeGesture.direction = .left
        self.view.addGestureRecognizer(leftSwipeGesture)
    }
    
    func setContentForScrollView() {
        let walletChildViews: [UIView] = [self.balanceView, self.sendView]
        var index = 0
        for subView in walletChildViews {
            changeFrame(for: subView, and: index)
            self.scrollView.addSubview(subView)
            
            index += 1
        }
    }
    
    func refreshScrollViewContentSize() {
        self.scrollView.contentSize = CGSize(width: self.view.bounds.size.width * 2, height: 1)

        if let _ = self.balanceView {
            changeFrame(for: self.balanceView, and: 0)
        }

        if let _ = self.sendView {
            changeFrame(for: self.sendView, and: 1)
        }
        
        DispatchQueue.main.async(execute: {
            self.scrollToPage(page: self.pageControl.currentPage, animated: false)
        })
    }
    
    func changeFrame(for childView: UIView, and page: Int) {
        var subViewFrame: CGRect    = CGRect.zero
        subViewFrame.origin.x       = self.view.bounds.size.width * CGFloat(page)
        subViewFrame.size           = CGSize(width: self.view.bounds.size.width, height: self.scrollView.bounds.size.height + 64)
        
        childView.frame             = subViewFrame
    }
    
    func addCustomViews() {
        self.balanceView                        = WalletBalanceView()
        self.balanceView.balanceDelegate        = self
        
        self.sendView                           = WalletSendView()
        self.sendView.sendDelegate              = self
        
        self.sendReceiptView                    = WalletSendReceiptView()
        self.sendReceiptView.receiptDelegate    = self
        
        self.withdrawView                       = WalletWithdrawView()
        self.withdrawView.withdrawDelegate      = self
        
        self.receiveView                        = WalletReceiveView()

        self.hiddenChildViews = [self.sendReceiptView, self.withdrawView, self.receiveView]
        addHiddenChildViews(self.hiddenChildViews)
        
        self.cryptoZoomView                     = CriptolikeZoomedView()
        let freeformViews: [UIView] = [self.cryptoZoomView]
        addHiddenFreeformViews(freeformViews)
    }
    
    func refreshTransactionsTable(_ list: [[Dictionary<String, Any>]]) {
        if list.count > 0 {
            self.balanceView.emptyTransactionsLabel.isHidden    = true
            self.transactionsTableView.isHidden                 = false
            
            self.transactionsArray = list
            
            self.transactionsTableView.reloadData()
            
            let topIndexPath = IndexPath(row: 0, section: 0)
            self.transactionsTableView.scrollToRow(at: topIndexPath, at: .top, animated: false)
        } else {
            self.balanceView.emptyTransactionsLabel.isHidden    = false
            self.transactionsTableView.isHidden                 = true
        }
    }
    
    func showQR(_ address: String, sender: UIButton) {
        if let keyWindow = UIApplication.shared.keyWindow {
            qrBackgroundView = UIView(frame: keyWindow.frame)
            qrButton = sender
            if !UIAccessibilityIsReduceTransparencyEnabled() {
                qrBackgroundView?.backgroundColor = .clear
                
                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                
                blurEffectView.frame = keyWindow.frame
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                qrBackgroundView?.addSubview(blurEffectView)
            } else {
                qrBackgroundView?.backgroundColor = .black
            }
            
            qrBackgroundView?.alpha = 0
            keyWindow.addSubview(qrBackgroundView!)
            keyWindow.backgroundColor = .clear
            
            let globalPoint = sender.superview!.convert(sender.center, to: self.qrBackgroundView!)
            
            let qrContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            imageView.contentMode = .scaleAspectFill
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.center = globalPoint
            
            let imageWidth = view.frame.size.width
            imageView.image = UIImage.generateQRImage(stringQR: address as NSString, withSizeRate: CGFloat(1), andWidth:imageWidth)
            qrContainerView.backgroundColor = .white
            qrContainerView.addSubview(imageView)
            imageView.frame.origin = CGPoint(x: 30, y: 30)
            qrView = qrContainerView
            qrBackgroundView?.addSubview(qrView!)
            qrBackgroundView?.bringSubview(toFront: qrView!)
            qrView?.layer.cornerRadius = 6
            qrView?.layer.masksToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.qrBackgroundView?.alpha = 1
                
                let width = UIScreen.main.bounds.size.width - 40
                self.qrView?.frame = CGRect(x: 0, y: 0, width: width, height: width)
                imageView.frame = CGRect(x: 0, y: 0, width: width - 60, height: width - 60)
                imageView.frame.origin = CGPoint(x: 30, y: 30)
                self.qrView?.center = self.qrBackgroundView!.center
                
            }) { (true) in
                let gr = UITapGestureRecognizer(target: self, action: #selector(self.handleQRTap(_:)))
                self.qrBackgroundView?.addGestureRecognizer(gr)
            }
        }
    }
    
    func addAdaptationUI() {
        let screenHeight = UIScreen.main.bounds.size.height
        
        let imageHeight = UIScreen.main.bounds.size.height / 3
        self.topImageViewHeightConstraint.constant          = imageHeight
        
        var heightValue = screenHeight - imageHeight
        
        if modelName == "iPhone X" || modelName == "x86_64" {
            heightValue -= 44
            
            UIApplication.shared.statusBarView?.backgroundColor = .clear
        }
        
        self.containerView.frame.size = CGSize(width: UIScreen.main.bounds.size.width,
                                               height: heightValue)
        self.scrollView.frame.size = CGSize(width: UIScreen.main.bounds.size.width,
                                            height: heightValue)
        
        let childViews: [UIView] = [self.balanceView, self.sendView, self.sendReceiptView, self.withdrawView, self.receiveView]
        
        for childView in childViews {
            if childView.isHidden == false {
                childView.frame.size = CGSize(width: childView.bounds.size.width,
                                              height: heightValue)
            }
        }
        
        if self.balanceView.isHidden == false {
            self.balanceView.changeBalanceWidthButtons()
        }
        
        if self.sendView.isHidden == false {
            self.sendView.changeSendWidthButtons()
        }
        
        if self.sendReceiptView.isHidden == false {
            self.sendReceiptView.changeUIConstraints()
        }
        
        if self.withdrawView.isHidden == false {
            self.withdrawView.changeWithdrawWidthButtons()
        }
        
        if self.receiveView.isHidden == false {
            self.receiveView.changeTopMargin()
        }
    }
    
    func setWalletPageTitle() {
        switch self.currentWalletPage {
            case WalletPages.UnselectPage.rawValue, WalletPages.BalancePage.rawValue:
                self.backButton.isHidden    = true
                
                self.navBarTitleLabel.text  = "WalletLabelTitle".localized(using: "WalletLocalizable")
            
                let userContactsCount = self.sendView.contactsList.count
                if userContactsCount == 1 {
                    self.sendView.cleanAllStates()
                    
                    self.presenter?.interactor?.loadContactsList()
                }
            case WalletPages.SendPage.rawValue:
                self.backButton.isHidden = false
                self.navBarTitleLabel.text  = "WalletSendTitle".localized(using: "WalletLocalizable")
            case WalletPages.WithdrawPage.rawValue:
                self.backButton.isHidden = false
                self.navBarTitleLabel.text  = "WalletWithdraw".localized(using: "WalletLocalizable")
            case WalletPages.ReceivePage.rawValue:
                self.backButton.isHidden = false
                self.navBarTitleLabel.text  = "WalletReceiveTitle".localized(using: "WalletLocalizable")
            case WalletPages.ReceiptPage.rawValue:
                self.backButton.isHidden = false
                self.navBarTitleLabel.text  = "WalletReceipt".localized(using: "WalletLocalizable")
            default:
                break
        }
    }
}
