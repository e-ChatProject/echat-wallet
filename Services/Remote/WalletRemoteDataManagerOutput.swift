//
//  WalletRemoteDataManagerOutput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletRemoteDataManagerOutput: class {
    
    func addressDidLoad(_ address: String)
    func addressDidLoadError(_ error: String)
    
    func transactionsDidLoad(_ list: [[Dictionary<String, Any>]])
    func transactionsDidLoadError(_ error: String)
    
    func contactsListDidLoad(_ list: [PONSOFriendProfile])
    func contactsListDidLoadError(_ error: String)
    
    func transferDidSend(_ check: String)
    func transferDidSendError(_ error: String)
    
    func withdrawDidSend(_ check: String)
    func withdrawDidSendError(_ error: String)
    
    func userProfileWasUpdated(_ userObject: PONSOUserProfile)
    func userProfileUpdatedError(_ error: String)
    
    func cryptolikeDetailsDidReceived(_ post: PONSOMoment)
    func cryptolikeDetailsDidReceivedError(_ error: String)
}
