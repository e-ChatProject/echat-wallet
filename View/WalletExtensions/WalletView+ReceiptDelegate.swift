//
//  WalletView+ReceiptDelegate.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: WalletReceiptViewDelegate {
    
    func walletReformButtonTapped() {
        self.currentWalletPage = WalletPages.SendPage.rawValue
        self.setWalletPageTitle()
        
        hideHiddenView(self.sendReceiptView)
    }
    
    func walletConfirmButtonTapped() {
        _ = checkNetworkConnection()
        
        presenter?.confirmTransferButtonTapped()
    }
}
