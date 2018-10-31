//
//  File.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 08.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletSendView: WalletAddFriendCellDelegate {
    
    func walletAddContactButtonTapped(_ sender: UIButton) {
        sendDelegate?.walletAddFriendButtonTapped()
    }
}


extension WalletSendView {
    
    func setSelectedUsername(_ contact: PONSOFriendProfile) {
        fillContacts([contact])
        fillAccountField(by: 0)
    }
}
