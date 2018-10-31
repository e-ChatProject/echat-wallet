//
//  WalletSendView+WalletFriendCellDelegate.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 08.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletSendView: WalletFriendCellDelegate {
    
    func walletContactButtonTapped(_ sender: UIButton) {
        let buttonTag = sender.tag
        if buttonTag >= 0 {
            fillAccountField(by: sender.tag)
        }
    }
}
