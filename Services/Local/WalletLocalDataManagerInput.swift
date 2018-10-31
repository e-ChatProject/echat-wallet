//
//  WalletLocalDataManagerInput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletLocalDataManagerInput: class {
    
    func updateUserProfileModel(_ userProfile: PONSOUserProfile)
}
