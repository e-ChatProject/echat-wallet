//
//  WalletBalanceView.swift
//  e-Chat
//
//  Created by Rostyslav on 4/23/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletBalanceView: WalletBaseView {

    @IBOutlet weak var walletReceiveButton: UIButton!
    @IBOutlet weak var walletSendButton: UIButton!
    @IBOutlet weak var filtersScrollView: UIScrollView!
    @IBOutlet weak var transactionsView: UIView!
    @IBOutlet weak var emptyTransactionsLabel: UILabel!
    @IBOutlet weak var receiveButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonsBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBottomMarginConstraint: NSLayoutConstraint!
    weak var balanceDelegate: WalletBalanceViewDelegate!
    var lastSelectedButtonTag: Int = FilterButtonsTags.AllFilterTag.rawValue
    
    
    override func addCustomizations() {
        self.walletReceiveButton.addStyleForBottomLetButton(with: "WalletReceiveTitle", in: "WalletLocalizable")

        self.emptyTransactionsLabel.text = "WalletBalanceEmptyTitle".localized(using: "WalletLocalizable")
        self.emptyTransactionsLabel.textColor = grayTitleColor
        
        addFiltersButtons()
        
        if modelName != "iPhone X" {
            self.bottomButtonsBottomMarginConstraint.constant       = 65
        }
        
        self.walletSendButton.addStyleForBottomRightButton(with: "WalletSendTitle", in: "WalletLocalizable")
    }

    func addFiltersButtons() {
        let filterButtonsTitles = ["TFilterAll".localized(using: "WalletLocalizable"),
                                   "TFilterSent".localized(using: "WalletLocalizable"),
                                   "TFilterReceived".localized(using: "WalletLocalizable"),
                                   "TFilterCryptolike".localized(using: "WalletLocalizable"),
                                   "TFilterWithdraw".localized(using: "WalletLocalizable")]
        var count = 0
        var buttonsViews: [String: UIButton] = [:]
        for title in filterButtonsTitles {
            let filterButton = UIButton()
            filterButton.backgroundColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.0)
            filterButton.tag = FilterButtonsTags.AllFilterTag.rawValue + count
            filterButton.setTitleColor(filterTitleColor, for: .normal)
            filterButton.setTitle(title, for: .normal)
            filterButton.setTitle(title, for: .highlighted)
            filterButton.setTitle(title, for: .selected)
            filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
            
            filterButton.addTarget(self, action: #selector(self.filterButtonPressed), for: .touchUpInside)

            filterButton.addToFilterButtonCorner(7)
            filterButton.addToFilterButtonShadow(buttonShadowColor.cgColor)
            
            self.filtersScrollView.addSubview(filterButton)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            
            let buttonViewTitle: String = String.init(format:"filterButton%d", count)
            let balanceViewValues = [buttonViewTitle: filterButton]
            buttonsViews[buttonViewTitle] = filterButton
            
            let vertFilterFormat = String.init(format:"V:|-(7)-[%@(20)]-(7)-|", buttonViewTitle)

            let balanceFormats = [vertFilterFormat]
            addConstraints(for:balanceViewValues, with:balanceFormats, to:self.filtersScrollView)

            count += 1
        }
        
        let horizFilterFormat: String = "H:|-(15)-[filterButton0(45)]-(10)-[filterButton1(90)]-(10)-[filterButton2(90)]-(10)-[filterButton3(90)]-(10)-[filterButton4(80)]-(15)-|"

        let filtersScrollViewContentWidth = (15 * 2) + 45 + (10 * 4) + (90 * 3) + 80
        addConstraint(to:self.filtersScrollView, with:horizFilterFormat, for:buttonsViews)
        
        self.filtersScrollView.contentSize = CGSize(width: filtersScrollViewContentWidth, height:1)
    }
    
    func addDefaultFilterSelection() {
        let allButton = self.filtersScrollView.viewWithTag(self.lastSelectedButtonTag) as! UIButton
        addGradient(for: allButton)
    }
    
    func addGradient(for button: UIButton) {
        if self.lastSelectedButtonTag >= 0 {
            let selectedButton: UIButton = self.filtersScrollView.viewWithTag(self.lastSelectedButtonTag) as! UIButton

            selectedButton.setTitleColor(filterTitleColor, for: .normal)
            
            if selectedButton.layer.sublayers!.count > 1 {
                selectedButton.layer.sublayers!.remove(at: 0)
            }
        }
            
        button.setTitleColor(.white, for: .normal)

        let leftSendColor: UIColor      = UIColor(red:0.55, green:0.48, blue:0.99, alpha:1.0)
        let rightSendColor: UIColor     = UIColor(red:0.35, green:0.63, blue:1.00, alpha:1.0)
        let sendGradientLayer           = CAGradientLayer()
        sendGradientLayer.frame         = CGRect(origin: .zero, size: button.frame.size)
        sendGradientLayer.colors        = [leftSendColor.cgColor, rightSendColor.cgColor]
        sendGradientLayer.startPoint    = CGPoint(x: 0.0, y: 0.5)
        sendGradientLayer.endPoint      = CGPoint(x: 1.0, y: 0.5)

        sendGradientLayer.cornerRadius  = 7
        sendGradientLayer.masksToBounds = true
        
        button.layer.insertSublayer(sendGradientLayer, at: 0)
    }
    
    func changeBalanceWidthButtons() {
        self.receiveButtonWidthConstraint.constant = bottomButtonsWidth
        self.sendButtonWidthConstraint.constant    = bottomButtonsWidth
    }
    
    @objc func filterButtonPressed(_ sender: UIButton) {
        addGradient(for: sender)

        self.lastSelectedButtonTag = sender.tag
        
        balanceDelegate?.walletFilterButtonTapped(sender.tag)
    }
    
    @IBAction func walletReceiveButtonPressed(_ sender: UIButton) {
        balanceDelegate?.walletReceiveButtonTapped()
    }
    
    @IBAction func walletSendButtonPressed(_ sender: UIButton) {
        balanceDelegate?.walletSendButtonTapped()
    }
}

protocol WalletBalanceViewDelegate:class {
    func walletReceiveButtonTapped()
    func walletSendButtonTapped()
    func walletFilterButtonTapped(_ tag: Int)
}
