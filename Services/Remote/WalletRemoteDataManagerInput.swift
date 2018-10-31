//
//  WalletRemoteDataManagerInput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletRemoteDataManagerInput: class {
    
    var remoteRequestHandler: WalletRemoteDataManagerOutput? { get set }
    
    func loadMerchantAddressInManager()
    func loadAccountTransactionsInManager()
    func loadContactsListInManager()
    
    func sendTransferInManager(_ userID: String, with amount: String)
    func sendWithdrawInManager(_ address: String, with amount: String)
    
    func updateUserInfo()
    
    func getCryptoLikeDetailsInManager(_ dynamicId: String)
}
