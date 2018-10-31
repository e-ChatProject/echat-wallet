//
//  WalletFriendCell.swift
//  e-Chat
//
//  Created by Rostyslav on 5/2/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


class WalletFriendCell: UICollectionViewCell {
    weak var walletFriendCellDelegate: WalletFriendCellDelegate!
    
    let avaImageView: UIImageView = {
        let imageView                   = UIImageView()
        imageView.backgroundColor       = .clear
        imageView.contentMode           = .scaleAspectFill
        imageView.layer.cornerRadius    = CGFloat(23)
        imageView.layer.masksToBounds   = true
        imageView.layer.shadowColor     = buttonShadowColor.cgColor
        imageView.layer.shadowOffset    = CGSize(width: 0.0, height: 2.0)
        imageView.layer.shadowOpacity   = 1.0
        imageView.layer.shadowRadius    = 0.0
        return imageView
    }()
    
    let contactTitle: UILabel = {
        let nameLabel            = UILabel()
        nameLabel.backgroundColor = .clear
        nameLabel.font           = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.semibold)
        nameLabel.lineBreakMode  = .byWordWrapping
        nameLabel.numberOfLines  = 2
        nameLabel.textAlignment  = .center
        nameLabel.textColor      = grayTitleColor
        return nameLabel
    }()
    
    let userLetterLabel: UILabel = {
        let letterLabel             = UILabel()
        letterLabel.backgroundColor = .clear
        letterLabel.font            = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        letterLabel.textAlignment   = .center
        letterLabel.textColor       = .white
        return letterLabel
    }()
    
    let contactButton: UIButton = {
        let button                  = UIButton()
        button.backgroundColor      = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCustomUI()
    }
    
    func addCustomUI() {
        self.contentView.backgroundColor      = friendsCellBgColor
        self.contentView.layer.cornerRadius   = CGFloat(10)
        
        self.contactButton.addTarget(self, action: #selector(self.contactButtonTapped), for: .touchUpInside)
        
        self.contentView.addSubview(self.avaImageView)
        self.contentView.addSubview(self.userLetterLabel)
        self.contentView.addSubview(self.contactTitle)
        self.contentView.addSubview(self.contactButton)
        
        self.userLetterLabel.isHidden = true
        
        let avaView     = ["ava":    self.avaImageView]
        let avaFormats  = ["H:|-(17)-[ava(46)]", "V:|-(5)-[ava(46)]"]
        addConstraints(for:avaView as [String : UIView], with:avaFormats, to:self.contentView)
        
        let letterView     = ["letter": self.userLetterLabel]
        let letterFormats  = ["H:|-(25)-[letter(30)]", "V:|-(10)-[letter(30)]"]
        addConstraints(for:letterView as [String : UIView], with:letterFormats, to:self.contentView)
        
        let titleView       = ["label":  self.contactTitle]
        let titleFormats    = ["H:|-(3)-[label]-(3)-|", "V:[label(27)]-(3)-|"]
        addConstraints(for:titleView as [String : UIView], with:titleFormats, to:self.contentView)
        
        let buttonView      = ["button":  self.contactButton]
        let buttonFormats   = ["H:|[button]|", "V:|[button]|"]
        addConstraints(for:buttonView as [String : UIView], with:buttonFormats, to:self.contentView)
    }
    
    func setFriendProfile(_ profile: PONSOFriendProfile) {
        self.avaImageView.image   = (UIImage(named: "gradient\(abs(profile.userID.hashValue) % 10)")!)
        
        self.userLetterLabel.isHidden   = true
        self.userLetterLabel.text       = ""
        
        if !profile.headImage.isEmpty {
            self.avaImageView.af_cancelImageRequest()
            if let url = URL(string: AppStringDefines.bucketImagePrefix.rawValue + profile.headImage) {
                self.avaImageView.af_setImage(withURL: url)
            }
        } else {
            self.userLetterLabel.isHidden = false
            
            let nickName = profile.nickName
            if let userLetter = nickName.uppercased().first {
                self.userLetterLabel.text = String(userLetter)
            }
        }
        
        if !profile.nickName.isEmpty {
            self.contactTitle.text  = profile.nickName
        }
    }
    
    @objc func contactButtonTapped(_ sender: UIButton) {
        walletFriendCellDelegate.walletContactButtonTapped(sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol WalletFriendCellDelegate: class {
    func walletContactButtonTapped(_ sender: UIButton)
}
