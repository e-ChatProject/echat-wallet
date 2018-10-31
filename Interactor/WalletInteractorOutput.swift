//
//  WalletInteractorOutput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletInteractorOutput: class {
    func loadAddress(_ address: String)
    func loadAddressError(_ error: String)
    
    func loadTransactions(_ list: [[Dictionary<String, Any>]])
    func loadTransactionsError(_ error: String)
    
    func loadContactsList(_ list: [PONSOFriendProfile])
    func loadContactsListError(_ error: String)
    
    func sendTransfer(_ result: String)
    func sendTransferError(_ error: String)
    
    func sendWithdraw(_ result: String)
    func sendWithdrawError(_ error: String)
    
    func userProfileUpdated()
    func userProfileUpdatedError(_ error: String)
    
    func cryptolikeDetailsReceived(_ post: PONSOMoment)
    func cryptolikeDetailsReceivedError(_ error: String)

}
