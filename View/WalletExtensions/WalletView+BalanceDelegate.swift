//
//  WalletView+BalanceDelegate.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: WalletBalanceViewDelegate {
    
    func walletFilterButtonTapped(_ tag: Int) {
        self.selectedFilter = tag

        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            self.filteredTransactions = self.transactionsCopyArray
            
            switch tag {
                case FilterButtonsTags.AllFilterTag.rawValue:
                    self.filterTransactions(by: BalanceFilterTypes.All.rawValue)
                case FilterButtonsTags.ReceivedFilterTag.rawValue:
                    self.filterTransactions(by: TransactionTypes.ReceivedType.rawValue)
                case FilterButtonsTags.SentFilterTag.rawValue:
                    self.filterTransactions(by: TransactionTypes.SentType.rawValue)
                case FilterButtonsTags.CryptolikesFilterTag.rawValue:
                    self.filterTransactionsByTag(BalanceFilterTypes.Cryptolike.rawValue)
                case FilterButtonsTags.WithdrawFilterTag.rawValue:
                    self.filterTransactionsByTag(BalanceFilterTypes.Withdraw.rawValue)
                default:
                    break
            }
            
            DispatchQueue.main.async {
                self.refreshTransactionsTable(self.filteredTransactions)
            }
        }
    }
    
    func walletReceiveButtonTapped() {
        self.currentWalletPage  = WalletPages.ReceivePage.rawValue
        setWalletPageTitle()
        
        self.currentWalletPage = WalletPages.ReceivePage.rawValue
        setWalletPageTitle()
        
        showHiddedView(self.receiveView)
    }
    
    func walletSendButtonTapped() {
        showSendPage()
    }
    
    func showWalletPage() {
        scrollToPage(page: 0, animated: true)
    }
    
    func showSendPage() {
        scrollToPage(page: 1, animated: true)
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        var frame: CGRect = self.scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(page);
        frame.origin.y = 0;
        self.scrollView.scrollRectToVisible(frame, animated: animated)
        
        self.pageControl.currentPage = page
        
        changePageTitle(by: page)
    }
    
    func changePageTitle(by page: Int) {
        switch page {
            case 0:
                self.currentWalletPage  = WalletPages.BalancePage.rawValue
                if self.balanceView.isHidden == true {
                    self.balanceView.isHidden = false
                }
            case 1:
                self.currentWalletPage  = WalletPages.SendPage.rawValue
            default:
                break
        }

        setWalletPageTitle()
    }
    
    func filterTransactions(by transtype: Int) {
        if self.filteredTransactions.count > 0 {
            var filteredTransactions: [Dictionary<String, Any>] = []
            
            for transactionsByDate in self.filteredTransactions {
                for transaction in transactionsByDate {
                    if let type = transaction["transtype"] as? String {
                        let typeValue: Int = Int(type)!
                        if transtype > BalanceFilterTypes.All.rawValue {
                            if typeValue == transtype {
                                if let subtype = transaction["type"] as? String {
                                    let subtypeValue: Int = Int(subtype)!
                                    switch transtype {
                                    case TransactionTypes.SentType.rawValue:
                                        if  subtypeValue != BalanceFilterTypes.Withdraw.rawValue &&
                                            subtypeValue != BalanceFilterTypes.Cryptolike.rawValue {
                                            filteredTransactions.append(transaction)
                                        }
                                    case TransactionTypes.ReceivedType.rawValue:
                                        if  subtypeValue != BalanceFilterTypes.Cryptolike.rawValue {
                                            filteredTransactions.append(transaction)
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                        } else {
                            filteredTransactions.append(transaction)
                        }
                    }
                }
            }
            
            
            if filteredTransactions.count > 0 {
                self.filteredTransactions = []
                self.filteredTransactions = Array<Any>.filterTransactions(filteredTransactions)
            } else {
                self.filteredTransactions = []
            }
        }
    }
    
    func filterTransactionsByTag(_ tag: Int) {
        if self.filteredTransactions.count > 0 {
            var filteredTransactions: [Dictionary<String, Any>] = []
            
            for transactionsByDate in self.filteredTransactions {
                for transaction in transactionsByDate {
                    if tag == BalanceFilterTypes.All.rawValue {
                        filteredTransactions.append(transaction)
                    } else {
                        if let type = transaction["type"] as? String {
                            let typeValue: Int = Int(type)!
                            if typeValue == tag {
                                filteredTransactions.append(transaction)
                            }
                        }
                    }
                }
            }
            
            if filteredTransactions.count > 0 {
                self.filteredTransactions = Array<Any>.filterTransactions(filteredTransactions)
            } else {
                self.filteredTransactions = []
            }
        }
    }
}
