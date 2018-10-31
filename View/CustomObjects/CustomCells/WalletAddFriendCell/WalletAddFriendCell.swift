//
//  WalletAddFriendCell.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 06.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


class WalletAddFriendCell: UICollectionViewCell {
    weak var walletAddFriendCellDelegate: WalletAddFriendCellDelegate!
    
    let bgImageView: UIImageView = {
        let imageView                   = UIImageView()
        imageView.image                 = UIImage(named:"newAccountButton")
        imageView.backgroundColor       = .clear
        imageView.contentMode           = .scaleAspectFill
        return imageView
    }()
    
    let itemTitle: UILabel = {
        let nameLabel            = UILabel()
        nameLabel.text           = "WalletNewAccount".localized(using: "WalletLocalizable")
        nameLabel.backgroundColor = .clear
        nameLabel.font           = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.semibold)
        nameLabel.lineBreakMode  = .byWordWrapping
        nameLabel.numberOfLines  = 2
        nameLabel.textAlignment  = .center
        nameLabel.textColor      = grayTitleColor
        return nameLabel
    }()
    
    let addFriendButton: UIButton = {
        let button                  = UIButton()
        button.backgroundColor      = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCustomUI()
    }
    
    func addCustomUI() {
        self.contentView.backgroundColor      = addFriendsCellBgColor
        self.contentView.layer.cornerRadius   = CGFloat(10)
        
        self.addFriendButton.addTarget(self, action: #selector(self.addFriendButtonTapped), for: .touchUpInside)
        
        self.contentView.addSubview(self.bgImageView)
        self.contentView.addSubview(self.itemTitle)
        self.contentView.addSubview(self.addFriendButton)
        
        let avaView     = ["bgImage":    self.bgImageView]
        let avaFormats  = ["H:|[bgImage]|", "V:|[bgImage]|"]
        addConstraints(for:avaView as [String : UIView], with:avaFormats, to:self.contentView)
        
        let titleView       = ["label":  self.itemTitle]
        let titleFormats    = ["H:|-(3)-[label]-(3)-|", "V:[label(27)]-(10)-|"]
        addConstraints(for:titleView as [String : UIView], with:titleFormats, to:self.contentView)
        
        let buttonView      = ["button":  self.addFriendButton]
        let buttonFormats   = ["H:|[button]|", "V:|[button]|"]
        addConstraints(for:buttonView as [String : UIView], with:buttonFormats, to:self.contentView)
    }

    
    @objc func addFriendButtonTapped(_ sender: UIButton) {
        walletAddFriendCellDelegate.walletAddContactButtonTapped(sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol WalletAddFriendCellDelegate: class {
    func walletAddContactButtonTapped(_ sender: UIButton)
}
