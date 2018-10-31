//
//  WalletViewOutput.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

protocol WalletViewOutput: class {
    
    var router: WalletRouterInput? { get set }
    var interactor: WalletInteractorInput? { get set }
    var view: WalletViewInput? { get set }
    
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
    
    func confirmTransferButtonTapped()
    func confirmWithdrawButtonTapped()
    
    func addFriendButtonTapped()
    
    func showQRScanner()
    
    func showSelectedUserProfile(_ userID: String)
    
    func showSelectedPost(_ post: PONSOMoment)
}
