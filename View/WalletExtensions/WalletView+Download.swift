//
//  WalletView+Download.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 08.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletView {
    
    func downloadData() {
        self.presenter?.interactor?.loadAccountAddress()
        
        self.presenter?.interactor?.loadContactsList()
        
        updateUserFinanceInfo()
        
        if let balanceString = UserLoginClient.sharedInstance.userProfile!.echatAmount {
            self.userBalance = (balanceString as NSString).doubleValue
        }
        
        refreshUserBalanceLabel()
    }
}
