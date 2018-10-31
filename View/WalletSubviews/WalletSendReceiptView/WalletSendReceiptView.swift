//
//  WalletSendReceiptView.swift
//  e-Chat
//
//  Created by Rostyslav on 4/20/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletSendReceiptView: WalletBaseView {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var confirmLabel: UILabel!
    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var letterLabel: UILabel!
    @IBOutlet weak var reformButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topLineTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLineLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLineRightMarginConstraint: NSLayoutConstraint!

    @IBOutlet weak var bottomLineLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLineRightMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var amountLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var amountRightMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dataTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataRightMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftPaperMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightPaperMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomPaperMarginConstraint: NSLayoutConstraint!

    @IBOutlet weak var bottomAmountMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTotalMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var reformButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonWidthConstraint: NSLayoutConstraint!
    
    weak var receiptDelegate: WalletReceiptViewDelegate!
    var targetContact: PONSOFriendProfile!
    var sendAmount: String = ""

    
    override func addCustomizations() {
        self.reformButton.addStyleForBottomLetButton(with: "WalletReform", in: "WalletLocalizable")

        self.photoImageView.layer.cornerRadius  = 15
        self.photoImageView.layer.masksToBounds = true
        
        let titleLabels: [UILabel] = [self.topTitleLabel, self.confirmLabel,  self.dateTitleLabel, self.timeTitleLabel, self.accountTitleLabel, self.totalTitleLabel]
        
        let titlesArray: [String] = ["WalletReceipt", "WalletConfirmInfo", "WalletDate", "WalletTime", "WalletAccount", "WalletTotal"]
        
        var count = 0
        for label in titleLabels {
            var titleString: String = titlesArray[count].localized(using: "WalletLocalizable")
            if count > 1 && count < titleLabels.count - 2 {
                titleString = titleString.uppercased()
            }
            
            label.text      = titleString
            label.textColor = grayTitleColor
            
            count += 1
        }
        
        self.topTitleLabel.textColor  = leftBlueColor
        self.totalLabel.textColor     = leftBlueColor
        
        self.confirmButton.addStyleForBottomRightButton(with: "WalletConfirm", in: "WalletLocalizable")
    }
    
    func setReciptValues(_ contact: PONSOFriendProfile, amount: String) {
        self.photoImageView.af_cancelImageRequest()
        self.photoImageView.image = UIImage(named: "gradient\(abs(contact.userID.hashValue) % 10)")
        
        if !contact.headImage.isEmpty {
            if let imageURL = URL(string: AppStringDefines.bucketImagePrefix.rawValue + contact.headImage) {
                self.photoImageView.af_setImage(withURL: imageURL)
            }
        } else {
            self.letterLabel.isHidden = false
            
            let nickName = contact.nickName
            if let userLetter = nickName.uppercased().first {
                self.letterLabel.text = String(userLetter)
            }
        }

        let currentDate: Date = Date()
        let dateString   = String.getDateTime(from: currentDate, by:"yyyy-MM-dd")
        
        let is24HoursFormat = String.is24Hours()
        var timeFormat      = "hh:mm"
        if is24HoursFormat {
            timeFormat = "HH:mm"
        }
        
        let timeString   = String.getDateTime(from: currentDate, by:timeFormat)
        
        self.accountLabel.text  = contact.nickName
        self.dateLabel.text     = dateString
        self.timeLabel.text     = timeString
        
        self.sendAmount         = amount
        
        self.totalLabel.text    = String.init(format:"%@ %@", amount, "ECHT".localized(using: "WalletLocalizable"))
    }
    
    func changeUIConstraints() {
        if modelName == "iPhone X" {
            self.topMarginConstraint.constant           = 37
            self.dataTopMarginConstraint.constant       = 40
            
            changeConstraintsForBigScreenPhones()
        } else if modelName == "iPhone 6 Plus" || modelName == "iPhone 6s Plus" || modelName == "iPhone 7 Plus" || modelName == "iPhone 8 Plus" {
            self.topMarginConstraint.constant           = 33
            self.dataTopMarginConstraint.constant       = 20
            
            changeConstraintsForBigScreenPhones()
        } else if modelName == "iPhone 8" || modelName == "iPhone 7" || modelName == "iPhone 6s" || modelName == "iPhone 6" {
            self.topMarginConstraint.constant           = 41
            self.dataTopMarginConstraint.constant       = 10
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            
            let screenHeight    = UIScreen.main.bounds.size.height
            let screenWidth     = UIScreen.main.bounds.size.width

            let leftPaperMargin     = screenWidth / 3.5
            let leftLineMargin      = screenWidth / 3.0

            var bottomPaperMargin   = screenHeight / 4.5
            var bottomAmountMargin  = screenWidth / 3.0
            
            var topLineTopMargin: CGFloat  = 21
            
            if modelName == "iPad Pro 10.5 Inch" {
                topLineTopMargin    = 31

            } else if modelName == "iPad Pro 12.9 Inch" || modelName == "iPad Pro 12.9 Inch 2. Generation"  {
                bottomPaperMargin   = screenHeight / 3.5
                bottomAmountMargin  = screenWidth / 2.3
                
                topLineTopMargin    = 37
            }
            
            self.leftPaperMarginConstraint.constant     = leftPaperMargin
            self.rightPaperMarginConstraint.constant    = leftPaperMargin
            self.bottomPaperMarginConstraint.constant   = bottomPaperMargin

            self.dataTopMarginConstraint.constant      = 30
            self.dataLeftMarginConstraint.constant     = leftLineMargin
            self.dataRightMarginConstraint.constant    = leftLineMargin
            
            self.topLineTopMarginConstraint.constant    = topLineTopMargin
            self.topLineLeftMarginConstraint.constant   = leftLineMargin
            self.topLineRightMarginConstraint.constant  = leftLineMargin
            
            self.bottomAmountMarginConstraint.constant  = bottomAmountMargin
            self.bottomTotalMarginConstraint.constant   = bottomAmountMargin
            
            self.bottomLineLeftMarginConstraint.constant    = leftLineMargin
            self.bottomLineRightMarginConstraint.constant   = leftLineMargin
            
            self.amountLeftMarginConstraint.constant    = leftLineMargin
            self.amountRightMarginConstraint.constant   = leftLineMargin
            
        } else {
            self.topMarginConstraint.constant           = 20
            self.dataTopMarginConstraint.constant       = 10
            self.topLineTopMarginConstraint.constant    = 11
            self.bottomAmountMarginConstraint.constant  = 35
            self.bottomTotalMarginConstraint.constant   = 35
        }
        
        self.reformButtonWidthConstraint.constant       = bottomButtonsWidth
        self.confirmButtonWidthConstraint.constant      = bottomButtonsWidth
        
        self.layoutIfNeeded()
    }
    
    func changeConstraintsForBigScreenPhones() {
        self.bottomPaperMarginConstraint.constant   = 80
        self.bottomAmountMarginConstraint.constant  = 80
        self.bottomTotalMarginConstraint.constant   = 80
    }
    
    @IBAction func reformButtonTapped(_ sender: UIButton) {
        self.endEditing(true)
        
        receiptDelegate?.walletReformButtonTapped()
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.endEditing(true)
        
        receiptDelegate?.walletConfirmButtonTapped()
    }
}

protocol WalletReceiptViewDelegate:class {
    func walletReformButtonTapped()
    func walletConfirmButtonTapped()
}
