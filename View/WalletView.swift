//
//  WalletView.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import AlamofireImage
import DRPLoadingSpinner


class WalletView: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var navBarTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var topImageViewHeightConstraint: NSLayoutConstraint!
    var balanceLabel: UILabel       = UILabel()
    var pageControl: UIPageControl  = UIPageControl()
    var balanceView: WalletBalanceView!
    var sendView: WalletSendView!
    var sendReceiptView: WalletSendReceiptView!
    var withdrawView: WalletWithdrawView!
    var receiveView: WalletReceiveView!
    var cryptoZoomView: CriptolikeZoomedView!
    var hiddenChildViews: [UIView] = []
    var transactionsTableView: UITableView!
    var transactionsArray: [[Dictionary<String, Any>]] = []
    var transactionsCopyArray: [[Dictionary<String, Any>]] = []
    var filteredTransactions: [[Dictionary<String, Any>]] = []
    var qrView: UIView?
    var qrBackgroundView: UIView?
    var qrButton: UIButton?
    var userAddress: String = ""
    @objc var refreshControl: DRPRefreshControl = DRPRefreshControl()
    var userBalance: Double = 0.0
    var presenter: WalletViewOutput?
    var selectedFilter: Int = -1
    var isRefreshControlTapped = false
    var currentWalletPage: Int = WalletPages.UnselectPage.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        
        addCustomUI()

        self.transactionsTableView.register(WalletViewTransactionCell.self, forCellReuseIdentifier: "WalletViewTransactionCell")
        self.transactionsTableView.register(WalletViewCryptolikeCell.self, forCellReuseIdentifier: "WalletViewCryptolikeCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setWalletPageTitle()
        
        self.navigationController?.isNavigationBarHidden = true
        
        if self.balanceView.isHidden == false && (self.currentWalletPage == WalletPages.UnselectPage.rawValue ||
                                                  self.currentWalletPage == WalletPages.BalancePage.rawValue) {
            downloadData()
        }

        addObservers()
        
        self.cryptoZoomView.hideAnimatedFreeformView()
        
        self.title = ""
    }


    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        setWalletPageTitle()
        
        addAdaptationUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.balanceView.isHidden == false {
            if let sendButton = self.balanceView.walletSendButton {
                sendButton.changeFirstLayerBounds()

                self.balanceView.addDefaultFilterSelection()
            }
        }
        
        if self.sendView.isHidden == false {
            if let nextButton = self.sendView.nextButton {
                nextButton.changeFirstLayerBounds()
            }
        }
        
        if self.sendReceiptView.isHidden == false {
            if let confirmButton = self.sendReceiptView.confirmButton {
                confirmButton.changeFirstLayerBounds()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        
        super.viewDidDisappear(animated)
    }
}


extension WalletView {
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * UIScreen.main.bounds.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    @objc func refreshControlAction(_ sender: Any) {
        self.refreshControl.endRefreshing()
        
        var selectedButton: UIButton = self.balanceView.viewWithTag(FilterButtonsTags.AllFilterTag.rawValue) as! UIButton        
        if self.selectedFilter > 0 {
            selectedButton = self.balanceView.viewWithTag(self.selectedFilter) as! UIButton
        }
        self.balanceView.addGradient(for: selectedButton)
        
        self.isRefreshControlTapped = true
        
        updateUserFinanceInfo()
    }
    
    @objc func handleQRTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.qrBackgroundView?.alpha = 0
            let globalPoint = self.qrButton!.superview!.convert(self.qrButton!.center, to: self.qrBackgroundView!)
            self.qrView?.frame = CGRect(x: globalPoint.x, y: globalPoint.y, width: 0, height: 0)
        }) { (true) in
            self.qrBackgroundView?.removeFromSuperview()
            self.qrBackgroundView = nil
            self.qrView?.removeFromSuperview()
            self.qrView = nil
            self.qrButton = nil
        }
    }

    @objc func topViewSwiped(_ gesture: UISwipeGestureRecognizer) {
        if self.pageControl.isHidden == true {
            return
        }
        
        if gesture.direction == .left {
            showSendPage()
        } else if gesture.direction == .right {
            showWalletPage()
        }
    }
}


extension WalletView {
    @IBAction func navBarButtonsTapped(_ sender: UIButton) {
        switch sender.tag {
            case backButtonTag:
                self.pageControl.isHidden   = false

                switch self.currentWalletPage {
                    case WalletPages.SendPage.rawValue:
                        scrollToPage(page: 0, animated: true)
                    case WalletPages.WithdrawPage.rawValue:
                        self.scrollView.isHidden   = false
                        self.balanceView.isHidden  = false
                    
                        goBackWithUpdate()
                    case WalletPages.ReceivePage.rawValue, WalletPages.ReceiptPage.rawValue:
                        goBackWithUpdate()
                    default:
                        break
                }

            case qrButtonTag:
                presenter?.showQRScanner()
            default:
                break
        }
    }
}
