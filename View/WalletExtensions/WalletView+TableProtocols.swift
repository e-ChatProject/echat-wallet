//
//  WalletView+TableProtocols.swift
//  e-Chat
//
//  Created by Rostyslav on 5/15/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit


extension WalletView: UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        let transactionValues: [String: Any] = self.transactionsArray[indexPath.section][indexPath.row]
        
        if let actionType = transactionValues["type"] as? String {
            let transactionType: Int = Int(actionType)!
            
            if transactionType == BalanceFilterTypes.Cryptolike.rawValue {
                let echtCell = tableView.dequeueReusableCell(withIdentifier: "WalletViewCryptolikeCell", for: indexPath) as! WalletViewCryptolikeCell

                echtCell.setCellValues(by: transactionValues)

                echtCell.cryptlikeImageView.isUserInteractionEnabled = true
                echtCell.cryptlikeImageView.indexPath = indexPath

                if echtCell.isNotEmptyEchtContent(in: transactionValues) {
                    if self.traitCollection.forceTouchCapability == .available {    // For 3D Touch devices
                        let deepTouchRecognizer = CryptolikeDeepToucher(target: self, action: #selector(self.gestureRecognized), hardAction:#selector(self.deepToucherRecognized))
                        deepTouchRecognizer.delegate = self
                        
                        echtCell.cryptlikeImageView.addGestureRecognizer(deepTouchRecognizer)
                    } else {                                                        // For non 3D Touch devices
                        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longGestureRecognized))
                        longPressRecognizer.minimumPressDuration    = 0.3
                        longPressRecognizer.numberOfTouchesRequired = 1
                        
                        echtCell.cryptlikeImageView.addGestureRecognizer(longPressRecognizer)
                    }
                } else {
                    echtCell.cryptlikeImageView.gestureRecognizers = []
                }
                
                cell = echtCell
            } else {
                let transactionCell = tableView.dequeueReusableCell(withIdentifier: "WalletViewTransactionCell", for: indexPath) as! WalletViewTransactionCell

                transactionCell.setCellLabels(by: transactionValues)
                
                cell = transactionCell
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.transactionsArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView: UIView = UIView()
        
        let transactionsByDay: [Dictionary<String, Any>]    = self.transactionsArray[section]
        let firstTransactionValues: [String: Any]           = transactionsByDay[0]
        
        let timestampValue: Int32   = firstTransactionValues["finishdate"] as! Int32
        let dateTitle: String       = String.detectDay(from:timestampValue)
        
        let titleLabel: UILabel     = UILabel()
        titleLabel.text             = dateTitle
        titleLabel.textColor        = grayTitleColor
        titleLabel.font             = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold)
        
        bgView.addSubview(titleLabel)
        
        let titleView     = ["title":    titleLabel]
        let titleFormats  = ["H:|-(15)-[title]-(15)-|", "V:|-(1)-[title]-(1)-|"]
        addConstraints(for:titleView as [String : UIView], with:titleFormats, to:bgView)
        
        return bgView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let transactionsByDay = self.transactionsArray[section]
        return transactionsByDay.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedTransaction = self.transactionsArray[indexPath.section][indexPath.row]
        
        if let actionType = selectedTransaction["type"] as? String {
            let type: Int = Int(actionType)!
            switch type {
            case BalanceFilterTypes.Recharge.rawValue:
                if let transType = selectedTransaction["transtype"] as? String {
                    let typeValue: Int = Int(transType)!
                    if typeValue == 1 {
                        return
                    }
                }
            case BalanceFilterTypes.Withdraw.rawValue:
                if let transType = selectedTransaction["transtype"] as? String {
                    let typeValue: Int = Int(transType)!
                    if typeValue == 2 {
                        return
                    }
                }
            default:
                break
            }
        }
        
        self.presenter?.showSelectedUserProfile(selectedTransaction["touserid"] as! String)
    }
}
