//
//  WalletDefinitions.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 05.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


// Colors
let purpleToColor: UIColor          = UIColor(red:0.55, green:0.48, blue:0.99, alpha:1.0)
let blueFromColor: UIColor          = UIColor(red:0.35, green:0.63, blue:1.00, alpha:1.0)
let bgViewColor: UIColor            = UIColor(red:0.97, green:0.97, blue:0.98, alpha:1.0)
let leftBlueColor: UIColor          = UIColor(red:0.35, green:0.63, blue:1.00, alpha:1.0)
let rightPurpleColor: UIColor       = UIColor(red:0.55, green:0.48, blue:0.99, alpha:1.0)
let buttonShadowColor: UIColor      = UIColor(red:0.91, green:0.91, blue:0.97, alpha:0.5)
let filterTitleColor                = UIColor(red:0.78, green:0.78, blue:0.80, alpha:1.0)
let grayTitleColor: UIColor         = UIColor(red:0.68, green:0.68, blue:0.69, alpha:1.0)
let graySeparatorColor: UIColor     = UIColor(red:0.90, green:0.90, blue:0.92, alpha:1.0)
let friendsCellBgColor: UIColor     = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
let addFriendsCellBgColor: UIColor  = UIColor(red:0.99, green:0.99, blue:0.99, alpha:0.5)



// Cells ids
// Send CollectionView cells ids
let addFriendCellId     = "WalletAddFriendCell"
let friendCellId        = "WalletFriendCell"
let groupCallCellId     = "GroupCallMemberCell"


// Button tags
let backButtonTag           = 100000
let qrButtonTag             = 100001


// Button width
let bottomButtonsWidth      = (UIScreen.main.bounds.size.width / 2) - 20


// Enums
enum BalanceFilterTypes: Int {
    case All             = 0
    case Recharge        = 1    // Transfer to ADDRESS
    case Transfer        = 2    // Transfer to ACCOUNT
    case Withdraw        = 3
    case MobileRecharge  = 4    // Not use now
    case EdrRecharge     = 5    // Not use now
    case Cryptolike      = 6
}

enum TransactionTypes: Int {
    case ReceivedType     = 1
    case SentType         = 2
}

enum WalletPages: Int {
    case UnselectPage   = 0
    case BalancePage
    case SendPage
    case WithdrawPage
    case ReceivePage
    case ReceiptPage
}

enum FilterButtonsTags: Int {
    case AllFilterTag           = 200000
    case SentFilterTag          = 200001
    case ReceivedFilterTag      = 200002
    case CryptolikesFilterTag   = 200003
    case WithdrawFilterTag      = 200004
}

enum EmptySendMoneyFieldsTypes: Int {
    case noAction = -1
    case emptyContact = 0
    case emptyTransferAmount
    case emptyAddress
    case emptyWithdrawAmount
    case showKeyboard
    case connectionError
}

enum ContactSearchTypes: Int {
    case nickName = 0
    case userName
}

enum PasteButtonStates: Int {
    case pasteState = 0
    case cleanState
}
