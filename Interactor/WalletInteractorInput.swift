//
//  WalletInteractorInput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletInteractorInput: class {
    
    var presenter: WalletInteractorOutput? { get set }
    var remoteDataManager: WalletRemoteDataManagerInput? { get set }
    var localDataManager: WalletLocalDataManagerInput? { get set }
    
    func loadAccountAddress()
    func loadAccountTransactions()
    func loadContactsList()
    
    func sendTransfer(_ userID: String, with amount: String)
    func sendWithdraw(_ address: String, with amount: String)
    
    func sendAmount(by amountType: Int, from view: WalletView?)
    
    func loadUserProfile()
    
    func loadCryptolikePostDetails(by dynamicId: String) 
}
