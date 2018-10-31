//
//  WalletView+SendDelegate.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: WalletSendViewDelegate {
    
    func walletAddFriendButtonTapped() {
        addFriend()
    }
    
    func walletWithdrawButtonTapped() {
        self.currentWalletPage = WalletPages.WithdrawPage.rawValue
        setWalletPageTitle()
        
        showHiddedView(self.withdrawView)
    }
    
    func walletNextButtonTapped(_ contact: PONSOFriendProfile?) {
        _ = checkNetworkConnection()
        
        let contactString: String = self.sendView.accountTextField.text!
        if contactString.isEmpty || contact == nil {
            showMessage("WalletEmptyContactMessage".localized(using: "WalletLocalizable"),
                        with:EmptySendMoneyFieldsTypes.emptyContact.rawValue)
            return
        }
        
        var moneyString: String     = self.sendView.amountTextField.text!
        if moneyString.isEmpty {
            showMessage("WalletEmptyMoneyMessage".localized(using: "WalletLocalizable"),
                        with:EmptySendMoneyFieldsTypes.emptyTransferAmount.rawValue)
            return
        } else {
            if moneyString.contains(",") {
                moneyString = moneyString.replacingOccurrences(of: ",", with: "", options: NSString.CompareOptions.literal, range: nil)
                moneyString.insert(".", at: moneyString.index(moneyString.startIndex, offsetBy: 1))
            }
            
            if moneyString.contains(".") {
                moneyString = moneyString.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)
                moneyString.insert(".", at: moneyString.index(moneyString.startIndex, offsetBy: 1))
            }
            
            let moneyAmount = moneyString.convertLocaleStringToNumber() ?? 0.0
            
            if moneyAmount == 0.0 {
                showMessage("WalletMinSendMoneyMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyTransferAmount.rawValue)
                return
            } else if moneyAmount > self.userBalance {
                showMessage("WalletMaxMoneyMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyTransferAmount.rawValue)
                return
            }  else if moneyAmount >= 99999 {
                showMessage("WalletLimitMoneyMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyTransferAmount.rawValue)
                return
            }
        }
        
        self.sendReceiptView.targetContact = contact
        self.sendReceiptView.sendAmount    = moneyString.formatArabicDoubleString()
        self.sendReceiptView.setReciptValues(contact!, amount: moneyString.formatArabicDoubleString())
        
        self.currentWalletPage = WalletPages.ReceiptPage.rawValue
        setWalletPageTitle()
        
        showHiddedView(self.sendReceiptView)
    }
    
    func showMessage(_ message: String, with type: Int) {
        let alert = UIAlertController(title: "Message".localized(using: "ProfileLocalizable"), message:message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action) in
            switch type {
                case EmptySendMoneyFieldsTypes.emptyContact.rawValue:
                    self.sendView.accountTextField.becomeFirstResponder()
                case EmptySendMoneyFieldsTypes.emptyTransferAmount.rawValue:
                    self.sendView.amountTextField.becomeFirstResponder()
                case EmptySendMoneyFieldsTypes.emptyAddress.rawValue:
                    self.withdrawView.receiverTextField.becomeFirstResponder()
                case EmptySendMoneyFieldsTypes.emptyWithdrawAmount.rawValue:
                    self.withdrawView.amountTextField.becomeFirstResponder()
                case EmptySendMoneyFieldsTypes.showKeyboard.rawValue:
                    self.withdrawView.receiverTextField.becomeFirstResponder()
                case EmptySendMoneyFieldsTypes.connectionError.rawValue:
                    print("No action")
                default:
                    break
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
