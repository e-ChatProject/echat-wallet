//
//  WalletInteractor.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

class WalletInteractor: WalletInteractorInput {
    var presenter: WalletInteractorOutput?
    var remoteDataManager: WalletRemoteDataManagerInput?
    var localDataManager: WalletLocalDataManagerInput?

    func loadAccountAddress() {
        remoteDataManager?.loadMerchantAddressInManager()
    }

    func loadAccountTransactions() {
        remoteDataManager?.loadAccountTransactionsInManager()
    }
    
    func loadContactsList() {
        remoteDataManager?.loadContactsListInManager()
    }
    
    func sendTransfer(_ userID: String, with amount: String) {
        remoteDataManager?.sendTransferInManager(userID, with: amount)
    }
    
    func sendWithdraw(_ address: String, with amount: String) {
        remoteDataManager?.sendWithdrawInManager(address, with: amount)
    }

    func loadUserProfile() {
        remoteDataManager?.updateUserInfo()
    }
    
    func sendAmount(by amountType: Int, from view: WalletView?) {
        if let walletView = view {
            switch amountType {
                case SendToServerTypes.transferType.rawValue:
                    if let targetContact: PONSOFriendProfile = walletView.sendReceiptView.targetContact {
                        let userID: String          = targetContact.userID
                        let amountString: String    = walletView.sendReceiptView.sendAmount
                        
                        if !userID.isEmpty && !amountString.isEmpty {
                            self.sendTransfer(userID, with: amountString.formatArabicDoubleString())
                        }
                    }
                case SendToServerTypes.withdrawType.rawValue:
                    let receiverString: String = walletView.withdrawView.receiverTextField.text!
                    let amountString: String = walletView.withdrawView.amountTextField.text!
                    
                    if !receiverString.isEmpty && !amountString.isEmpty {
                        self.sendWithdraw(receiverString, with: amountString)
                    }
                default:
                    break
            }
        }
    }
    
    func loadCryptolikePostDetails(by dynamicId: String) {
        remoteDataManager?.getCryptoLikeDetailsInManager(dynamicId)
    }
}

extension WalletInteractor: WalletRemoteDataManagerOutput {
    func cryptolikeDetailsDidReceived(_ post: PONSOMoment) {
        presenter?.cryptolikeDetailsReceived(post)
    }
    
    func cryptolikeDetailsDidReceivedError(_ error: String) {
        presenter?.cryptolikeDetailsReceivedError(error)
    }
    
    // Load address for receive page
    func addressDidLoad(_ address: String) {
        presenter?.loadAddress(address)
    }
    
    func addressDidLoadError(_ error: String) {
        presenter?.loadAddressError(error)
    }
    
    // Load transactions
    func transactionsDidLoad(_ list: [[Dictionary<String, Any>]]) {
        presenter?.loadTransactions(list)
    }
    
    func transactionsDidLoadError(_ error: String) {
        presenter?.loadTransactionsError(error)
    }
    
    func contactsListDidLoad(_ list: [PONSOFriendProfile]) {
        presenter?.loadContactsList(list)
    }
    
    func contactsListDidLoadError(_ error: String) {
        presenter?.loadContactsListError(error)
    }
    
    func transferDidSend(_ check: String) {
        presenter?.sendTransfer(check)
    }
    
    func transferDidSendError(_ error: String) {
        presenter?.sendTransferError(error)
    }
    
    func withdrawDidSend(_ check: String) {
        presenter?.sendWithdraw(check)
    }
    
    func withdrawDidSendError(_ error: String) {
        presenter?.sendWithdrawError(error)
    }
    
    func userProfileWasUpdated(_ userObject: PONSOUserProfile) {
        localDataManager?.updateUserProfileModel(userObject)
        
        presenter?.userProfileUpdated()
    }
    
    func userProfileUpdatedError(_ error: String) {
        presenter?.userProfileUpdatedError(error)
    }
}
