//
//  WalletViewTransactionCell.swift
//  e-Chat
//
//  Created by Rostyslav on 4/26/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletViewTransactionCell: WalletBaseCell {
    
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addCustomizations()
        
        let textContainer: UIView = createFilledTextContainer()
        
        let childViews = ["ava":     self.avaImageView,
                          "text":    textContainer,
                          "money":   self.moneyLabel,
                          "letter":  self.userLetterLabel]
 
        let childViewsConstraints: [String] = [String.init(format: "H:|-(%d)-[ava(%d)]", rightMargin, avaSize),
                                               String.init(format: "V:[ava(%d)]", avaSize),
                                               "H:|-(60)-[text]",
                                               "V:[text(48)]",
                                               String.init(format: "H:[money(90)]-(%d)-|", rightMargin),
                                               "V:[money(15)]",
                                               String.init(format: "H:|-(%d)-[letter(%d)]", rightMargin, avaSize),
                                               String.init(format: "V:|-(%d)-[letter(%d)]", rightMargin, avaSize)]
        
        addSubviews(childViews, to:self.bgView, with:childViewsConstraints)
        
        addCenterY(to: self.bgView, for: self.avaImageView)
        addCenterY(to: self.bgView, for: textContainer)
        addCenterY(to: self.bgView, for: self.moneyLabel)

        let childBgView = ["bgView":     self.bgView]
        let childBgViewConstraints: [String] = ["H:|[bgView]|",
                                                "V:|-(5)-[bgView]-(5)-|"]
        addSubviews(childBgView, to:contentView, with:childBgViewConstraints)

        contentView.layoutIfNeeded()
    }
    
    func addCustomizations() {
        self.backgroundColor                        = .clear
        contentView.backgroundColor                 = .clear
        
        self.nameLabel.textColor            = .black
        self.nameLabel.numberOfLines        = 2
        self.nameLabel.lineBreakMode        = .byWordWrapping
        
        self.dateLabel.textColor            = grayTitleColor
        
        self.moneyLabel.textAlignment       = .right
        
        self.userLetterLabel.textAlignment  = .center
        self.userLetterLabel.textColor      = .white
        
        addFontAdaptations()
        
        addCornerRound()
    }
 
    func setCellLabels(by values: [String: Any]) {
        var directionTitle: String      = ""
        var moneyAction: String         = ""
        var transactionTitle: String    = ""
        
        self.userLetterLabel.isHidden = true
        self.userLetterLabel.text     = ""
        
        if let userHash = values["touserid"] as? String {
            self.avaImageView.image = UIImage(named: "gradient\(abs(userHash.hashValue) % 10)")
        }
        
        self.avaImageView.af_cancelImageRequest()
        if let image = values["toUserHeadImg"] as? String {
            if !image.isEmpty {
                if let url = URL(string: AppStringDefines.bucketImagePrefix.rawValue + image) {
                    self.avaImageView.af_setImage(withURL: url)
                }
            } else {
                self.userLetterLabel.isHidden = false
                if let toUser = values["tousernickname"] as? String {
                    if let userLetter = toUser.uppercased().first {
                        self.userLetterLabel.text = String(userLetter)
                    }
                }
            }
        }
        
        if let actionType = values["transtype"] as? String {
            let type: Int = Int(actionType)!
            switch type {
                case TransactionTypes.ReceivedType.rawValue:
                    directionTitle              = "WalletContactFrom".localized(using: "WalletLocalizable")
                    moneyAction                 = "+"
                    self.moneyLabel.textColor   = leftBlueColor
                    transactionTitle            = "WalletReceived".localized(using: "WalletLocalizable")
                case TransactionTypes.SentType.rawValue:
                    directionTitle              = "WalletContactTo".localized(using: "WalletLocalizable")
                    moneyAction                 = "-"
                    self.moneyLabel.textColor   = rightPurpleColor
                    transactionTitle            = "WalletSent".localized(using: "WalletLocalizable")
                default:
                    break
            }
        }
        
        var echtTitleString = ""
        var incognitoString = ""
        if let actionType = values["type"] as? String {
            let type: Int = Int(actionType)!
            if type == BalanceFilterTypes.Withdraw.rawValue {
                transactionTitle = "WalletWithdrawCellTitle".localized(using: "WalletLocalizable")
            }
        }

        echtTitleString  = String.init(format:"%@ %@", transactionTitle, directionTitle)

        if let actionType = values["type"] as? String {
            let userLetter = "WalletIncognito".localized(using: "WalletLocalizable").first
            
            let type: Int = Int(actionType)!
            switch type {
                case BalanceFilterTypes.Recharge.rawValue:
                    if let transType = values["transtype"] as? String {
                        let typeValue: Int = Int(transType)!
                        if typeValue == TransactionTypes.ReceivedType.rawValue {
                            incognitoString = "WalletIncognito".localized(using: "WalletLocalizable")
                            
                            self.userLetterLabel.text = String(userLetter!)
                        }
                    }
                case BalanceFilterTypes.Withdraw.rawValue:
                    if let transType = values["transtype"] as? String {
                        let typeValue: Int = Int(transType)!
                        if typeValue == TransactionTypes.SentType.rawValue {
                            incognitoString = "WalletIncognito".localized(using: "WalletLocalizable")
                            
                            self.userLetterLabel.text = String(userLetter!)
                        }
                    }
                default:
                    break
            }
        }
        
        self.echtTitleLabel.text        = echtTitleString
        
        if !incognitoString.isEmpty {
            self.nameLabel.text = incognitoString
        } else if let toUser = values["tousernickname"] as? String {
            self.nameLabel.text = toUser
        }
        
        if let money = values["money"] as? String {
            let moneyValue: Double = Double(money)!
            if moneyValue == 0.0 {
                self.moneyLabel.text = String.init(format:"%.1f %@", moneyValue, "ECHT".localized(using: "ProfileLocalizable"))
            } else {
                self.moneyLabel.text = String.init(format:"%@ %.2f %@", moneyAction, moneyValue, "ECHT".localized(using: "ProfileLocalizable"))
            }
        }
        
        if let date = values["finishdate"] as? Int32 {
            let dateString = String.detectContactDay(from: date)
            
            self.dateLabel.text = dateString
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
