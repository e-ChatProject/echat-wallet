//
//  WalletView+WithdrawDelegate.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: WalletWithdrawViewDelegate {
    
    func withdrawConfirmButtonTapped() {
        let receiverString: String = self.withdrawView.receiverTextField.text!
        var amountString: String   = self.withdrawView.amountTextField.text!
        
        _ = checkNetworkConnection()
        
        if amountString.isEmpty {
            showMessage("WalletEmptyMoneyMessage".localized(using: "WalletLocalizable"),
                        with:EmptySendMoneyFieldsTypes.emptyWithdrawAmount.rawValue)
            return
        } else {
            amountString = amountString.replacingOccurrences(of: ",", with: ".", options: NSString.CompareOptions.literal, range: nil)
            let moneyAmount: Double     = Double(amountString)!
            
            if moneyAmount < 20.0 {
                showMessage("WalletMinMoneyMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyWithdrawAmount.rawValue)
                return
            } else if moneyAmount > self.userBalance {
                showMessage("WalletMaxMoneyMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyWithdrawAmount.rawValue)
                return
            }  else if moneyAmount >= 99999 {
                showMessage("WalletLimitMoneyMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyWithdrawAmount.rawValue)
                return
            }
        }
        
        if receiverString.isEmpty {
            showMessage("WalletEmptyAddressMessage".localized(using: "WalletLocalizable"),
                        with:EmptySendMoneyFieldsTypes.emptyAddress.rawValue)
            return
        } else {
            let isRightFistChar = receiverString.hasPrefix("0")
            if receiverString.count < 20 || receiverString.count > 70 || isRightFistChar == false {
                showMessage("WalletWrongAddressMessage".localized(using: "WalletLocalizable"),
                            with:EmptySendMoneyFieldsTypes.emptyAddress.rawValue)
                return
            }
        }
        
        let withdrawMessage = String.init(format:"\n%@ \n\n%@ %@ \n\n%@ \n\n%@", "WalletConfirmMessage".localized(using: "WalletLocalizable"), amountString, "ECHT".localized(using: "WalletLocalizable"), "WalletToAddress".localized(using: "WalletLocalizable"), receiverString)
        
        let confirmAlert = UIAlertController(title: "WalletConfirmWithdraw".localized(using: "WalletLocalizable"), message:withdrawMessage, preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .destructive, handler: { (action) in
        }))
        confirmAlert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [unowned self] (action) in
            self.presenter?.confirmWithdrawButtonTapped()
        }))
        
        present(confirmAlert, animated: true, completion: nil)
    }
    
    func withdrawPasteAddressButtonTapped() {
        let receiverString = self.withdrawView.receiverTextField.text!
        
        if receiverString.isEmpty {
            let pasteboardString: String? = UIPasteboard.general.string
            if let address = pasteboardString {
                if address.hasPrefix("0") {
                    self.withdrawView.receiverTextField.text = address
                    self.withdrawView.pasteButton.setBgImageForAllStates(UIImage(named:"walletCleanButton")!)
                    self.withdrawView.changePasteButtonConstraints(by:PasteButtonStates.cleanState.rawValue)
                    self.withdrawView.amountTextField.becomeFirstResponder()
                } else {
                    self.withdrawView.pasteButton.setBgImageForAllStates(UIImage(named:"pasteAddressButton")!)
                    self.withdrawView.changePasteButtonConstraints(by:PasteButtonStates.pasteState.rawValue)
                    showMessage("WalletEnterWrongQrMessage".localized(using: "WalletLocalizable"), with:EmptySendMoneyFieldsTypes.showKeyboard.rawValue)
                }
            }
        } else {
            self.withdrawView.pasteButton.setBgImageForAllStates(UIImage(named:"pasteAddressButton")!)
            self.withdrawView.changePasteButtonConstraints(by:PasteButtonStates.pasteState.rawValue)
            self.withdrawView.receiverTextField.text = ""
            
            self.withdrawView.receiverTextField.becomeFirstResponder()
        }
    }
    
    func withdrawShowWrongReciverMessage() {
        showMessage("WalletEnterWrongQrMessage".localized(using: "WalletLocalizable"), with:EmptySendMoneyFieldsTypes.connectionError.rawValue)
    }
}
