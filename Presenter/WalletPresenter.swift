//
//  WalletPresenter.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

enum SendToServerTypes: Int {
    case transferType = 0
    case withdrawType
}

class WalletPresenter: WalletViewOutput {
    var router: WalletRouterInput?
    var interactor: WalletInteractorInput?
    var view: WalletViewInput?
    var sendAmountType: Int = -1
    
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear(_ animated: Bool) {
        
    }
    
    func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func confirmTransferButtonTapped() {
        self.sendAmountType = SendToServerTypes.transferType.rawValue
        showPinView()
    }
    
    func confirmWithdrawButtonTapped() {
        self.sendAmountType = SendToServerTypes.withdrawType.rawValue
        showPinView()
    }
    
    func showPinView() {
        router?.showPin(on: (view as! UIViewController), with: self)
    }

    func showQRScanner() {
        if let viewController = view as? WalletView {
            router?.presentQRScanner(fromView: viewController, output: self)
        }
    }
    
    func addFriendButtonTapped() {
        router?.presentAddContact(from: view!, with: self)
    }
    
    func showSelectedUserProfile(_ userID: String) {
        router?.showUserProfile(from: view!, userID: userID)
    }
    
    func showSelectedPost(_ post: PONSOMoment) {
        router?.showDetailsPost(from: view!, and: post, output: self)
    }
}

extension WalletPresenter: WalletInteractorOutput {
    
    func userProfileUpdated() {
        view?.userProfileDidUpdated()
    }
    
    func userProfileUpdatedError(_ error: String) {
        view?.showError(error)
    }
    
    // Load address
    func loadAddress(_ address: String) {
        view?.showAddress(address)
    }
    
    func loadAddressError(_ error: String) {
        view?.showAddressError(error)
    }
    
    // Load transactions list
    func loadTransactions(_ list: [[Dictionary<String, Any>]]) {
        view?.showTransactions(list)
    }
    
    func loadTransactionsError(_ error: String) {
        view?.showTransactionsError(error)
    }
    
    func loadContactsList(_ list: [PONSOFriendProfile]) {
        view?.showContactsList(list)
    }
    
    func loadContactsListError(_ error: String) {
        view?.showContactsListError(error)
    }
    
    func sendTransfer(_ result: String) {
        view?.showAlertAfterChangeBalance(result)
    }
    
    func sendTransferError(_ error: String) {
        view?.showError(error)
    }
    
    func sendWithdraw(_ result: String) {
        view?.showAlertAfterChangeBalance(result)
    }
    
    func sendWithdrawError(_ error: String) {
        view?.showError(error)
    }
    
    func cryptolikeDetailsReceived(_ post: PONSOMoment) {
        view?.openCryptoLikeDetailsScreen(with: post)
    }
    
    func cryptolikeDetailsReceivedError(_ error: String) {
        view?.showError(error)
    }
}

extension WalletPresenter: PinLockModuleOutput {
    
    func pinViewDidCancelled() {

    }
    
    func pinViewAuthorized() {
        sendAmount()
    }
    
    func pinViewUnauthorized() {
        view?.showError("WalletWrongPinMessage".localized(using: "WalletLocalizable"))
    }
    
    func pinCodeSet() {
        sendAmount()
    }
    
    func sendAmount() {
        interactor?.sendAmount(by: self.sendAmountType, from: (view as! WalletView))
    }
}

extension WalletPresenter: QRScannerModuleOutput {
    
    func didScanCode(code: String) {
        view?.qrDidScanned(code, on: view as? WalletView)
    }
}

extension WalletPresenter: AddContactModuleOutput {
    
    func didSelectContact(_ contact: PONSOFriendProfile) {
        view?.newFriendDidSelected(contact)
    }
}

extension WalletPresenter: MomentInfoModuleOutput {
    
}
