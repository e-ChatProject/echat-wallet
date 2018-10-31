//
//  WalletView+WalletViewInput.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: WalletViewInput {
    
    func showAlertAfterChangeBalance(_ message: String) {
        let alert = UIAlertController(title: "Message".localized(using: "ProfileLocalizable"), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [unowned self] (action) in
            self.presenter?.interactor?.loadUserProfile() //Refresh balance after sent amount
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error".localized(), message:error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action) in

        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func userProfileDidUpdated() {
        var currentBalance: Double = 0.0

        if let balanceString = UserLoginClient.sharedInstance.userProfile!.echatAmount {
            currentBalance = (balanceString as NSString).doubleValue
        }
        
        self.userBalance = currentBalance
        self.refreshUserBalanceLabel()
        
        self.sendView.cleanInputFields()
        self.withdrawView.cleanInputFields()
        
        for hiddenView in self.hiddenChildViews {
            self.hideHiddenView(hiddenView)
        }
        
        self.showWalletPage()
        self.showBalanceView(self.balanceView)
        
        self.presenter?.interactor?.loadAccountTransactions()
    }
    
    func qrDidScanned(_ code: String, on view: WalletView?) {
        if let viewController = view {
            viewController.dismiss(animated: true, completion: nil)
            
            let isContaintsDigits = String.isContainsNumbers(in: code)
            
            if code.hasPrefix("0") {
                if viewController.receiveView.isHidden == false {
                    viewController.receiveView.isHidden = true
                }
                
                viewController.showWithdrawView(code)
            } else if isContaintsDigits {
                viewController.showSendView(code)
            } else {
                viewController.showMessage("WalletScanWrongQrMessage".localized(using: "WalletLocalizable"), with:EmptySendMoneyFieldsTypes.noAction.rawValue)
            }
        }
    }
    
    func showAddress(_ address: String) {
        self.receiveView.convertAddressToQr(address as NSString)
        self.userAddress = address              //Copy address for pass to QR
    }
    
    func showAddressError(_ error: String) {
        showApiError("WalletAddressLoadError".localized(using: "WalletLocalizable"))
    }
    
    func showTransactions(_ list: [[Dictionary<String, Any>]]) {
        self.transactionsCopyArray  = list

        if self.isRefreshControlTapped == true {
            self.isRefreshControlTapped = false
        
            if self.balanceView.lastSelectedButtonTag > FilterButtonsTags.AllFilterTag.rawValue {
                walletFilterButtonTapped(self.balanceView.lastSelectedButtonTag)
            }
        } else {
            if self.selectedFilter == -1 {
                walletFilterButtonTapped(FilterButtonsTags.AllFilterTag.rawValue)
            } else {
                walletFilterButtonTapped(self.selectedFilter)
            }
            
        }
    }
    
    func showTransactionsError(_ error: String) {
        showApiError("WalletTransactionsLoadError".localized(using: "WalletLocalizable"))
    }
    
    func showContactsList(_ list: [PONSOFriendProfile]) {
        self.sendView.fillContacts(list)
    }
    
    func showContactsListError(_ error: String) {
        showApiError("WalletContactsListLoadError".localized(using: "WalletLocalizable"))
    }
    
    func showApiError(_ error: String) {
        let alert = UIAlertController(title: "Error".localized(), message:error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (action) in

        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showWithdrawView(_ code: String) {
        if code.hasPrefix("0") {
            self.pageControl.isHidden       = true
            self.balanceView.isHidden       = true
            self.scrollView.isHidden        = true
    
            self.withdrawView.alpha         = 0
            UIView.animate(withDuration: 0.5,
                           delay: 0.2,
                           options: .transitionCrossDissolve,
                           animations: {
                            self.withdrawView.isHidden   = false
                            self.withdrawView.alpha      = 1
            }, completion: { finished in
                self.withdrawView.receiverTextField.text = code
                self.withdrawView.amountTextField.becomeFirstResponder()
            })
        }
    }
    
    func showSendView(_ address: String) {
        self.sendView.isHidden          = false
        self.pageControl.isHidden       = false
        self.scrollView.isHidden        = false
        
        self.withdrawView.isHidden      = true
        self.balanceView.isHidden       = true
        self.sendReceiptView.isHidden   = true
        self.receiveView.isHidden       = true

        self.showSendPage()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {        
            self.sendView.findContact(by: ContactSearchTypes.userName.rawValue, and: address)
            if self.sendView.contactsList.count > 0 {
                self.sendView.selectedContact        = self.sendView.contactsList[0]
                self.sendView.accountTextField.text  = self.sendView.selectedContact.nickName

                self.sendView.openAmountTextField()
            } else {
                self.showApiError("WalletScanQRforNotFriendMessage".localized(using: "WalletLocalizable"))
            }
        }
    }
    
    func refreshUserBalanceLabel() {
        let currencyTitle = "ECHT".localized(using: "ProfileLocalizable")
        self.balanceLabel.text = String.init(format:"%.2f %@", self.userBalance, currencyTitle)
    }
    
    func addFriend() {
        self.presenter?.addFriendButtonTapped()
    }
    
    func newFriendDidSelected(_ contact: PONSOFriendProfile) {
        self.sendView.setSelectedUsername(contact)
    }
    
    func openCryptoLikeDetailsScreen(with post: PONSOMoment) {
        self.presenter?.showSelectedPost(post)
    }
}
