//
//  WalletSendView+CollectionView.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 08.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletSendView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell = UICollectionViewCell()
        
        if indexPath.item > 0 {
            let friendCell: WalletFriendCell = collectionView.dequeueReusableCell(withReuseIdentifier: friendCellId, for: indexPath) as! WalletFriendCell
            
            
            
            if friendCell.walletFriendCellDelegate == nil {
                friendCell.walletFriendCellDelegate = self
            }
            
            if self.contactsList.count > 0 {
                let itemCount                   = indexPath.item - 1
                friendCell.contactButton.tag    = itemCount

                let friendProfile = self.contactsList[itemCount]
                if !friendProfile.nickName.isEmpty {
                    friendCell.setFriendProfile(friendProfile)
                }
            }
            
            cell = friendCell
        } else {
            let addCell: WalletAddFriendCell = collectionView.dequeueReusableCell(withReuseIdentifier: addFriendCellId, for: indexPath) as! WalletAddFriendCell
            
            if addCell.walletAddFriendCellDelegate == nil {
                addCell.walletAddFriendCellDelegate = self
            }
            
            addCell.addFriendButton.tag = 0
            
            cell = addCell
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.contactsList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
