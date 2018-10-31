//
//  WalletViewInput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletViewInput: class {
    
    var presenter: WalletViewOutput? { get set }
    
    func showAddress(_ address: String)
    func showAddressError(_ error: String)
    
    func showTransactions(_ list: [[Dictionary<String, Any>]])
    func showTransactionsError(_ error: String)
    
    func showContactsList(_ list: [PONSOFriendProfile])
    func showContactsListError(_ error: String)
    
    func showWithdrawView(_ code: String)
    
    func qrDidScanned(_ code: String, on view: WalletView?)
    
    func userProfileDidUpdated()
    
    func showAlertAfterChangeBalance(_ message: String)
    func showError(_ error: String)
    
    func newFriendDidSelected(_ contact: PONSOFriendProfile)
    
    func openCryptoLikeDetailsScreen(with post: PONSOMoment)
}
