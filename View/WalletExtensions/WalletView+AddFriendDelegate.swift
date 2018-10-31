//
//  WalletView+AddFriendDelegate.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 07.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletView: WalletAddFriendCellDelegate {
    
    func walletAddContactButtonTapped(_ sender: UIButton) {
        addFriend()
    }
}
