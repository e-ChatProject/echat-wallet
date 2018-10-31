//
//  WalletRouterInput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletRouterInput: class {
    
    static func createWalletModule() -> UIViewController 

    func presentQRScanner(fromView: WalletViewInput, output: QRScannerModuleOutput)

    func showPin(on view: UIViewController?, with presenter: WalletViewOutput)
    
    func presentAddContact(from wallet: WalletViewInput, with output: AddContactModuleOutput)
    
    func showUserProfile(from wallet: WalletViewInput, userID: String)
    
    func showDetailsPost(from wallet: WalletViewInput, and post: PONSOMoment, output: MomentInfoModuleOutput)
}
