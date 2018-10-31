//
//  WalletBaseCell.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 25.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


class WalletBaseCell: UITableViewCell {
    let bgView                              = UIView()
    let avaImageView: UIImageView           = UIImageView()
    let cryptlikeImageView: CLImageView     = CLImageView()
    let echtTitleLabel: UILabel             = UILabel()
    let nameLabel: UILabel                  = UILabel()
    let dateLabel: UILabel                  = UILabel()
    let moneyLabel                          = UILabel()
    let userLetterLabel                     = UILabel()
    
    var rightMargin: Int {
        let rightMargin: Int = 8
        return rightMargin
    }
    
    var avaSize: Int {
        let avaSize: Int     = 44
        return avaSize
    }
    
    var textWidth: Int {
        let textWidth: Int   = 130
        return textWidth
    }

    func createFilledTextContainer() -> UIView {
        let textContainer: UIView = UIView()
        let textChildViews = ["echt":    self.echtTitleLabel,
                              "name":    self.nameLabel,
                              "date":    self.dateLabel]

        let textConstraints: [String] = [String.init(format: "H:|[echt(%d)]", textWidth),
                                         String.init(format: "H:|[name(%d)]", textWidth),
                                         "H:|[date(150)]",
                                         "V:|[echt(16)]-(1)-[name(16)]-(1)-[date(14)]"]

        addSubviews(textChildViews, to:textContainer, with:textConstraints)
        
        return textContainer
    }
    
    func addFontAdaptations() {
        if modelName == "iPhone SE" {
            self.echtTitleLabel.font            = UIFont.systemFont(ofSize: 8, weight: .medium)
            self.nameLabel.font                 = UIFont.systemFont(ofSize: 8, weight: .bold)
            self.dateLabel.font                 = UIFont.systemFont(ofSize: 8, weight: .medium)
            self.moneyLabel.font                = UIFont.systemFont(ofSize: 7.5, weight: .bold)
        } else {
            self.echtTitleLabel.font            = UIFont.systemFont(ofSize: 12, weight: .medium)
            self.nameLabel.font                 = UIFont.systemFont(ofSize: 12, weight: .bold)
            self.dateLabel.font                 = UIFont.systemFont(ofSize: 10, weight: .medium)
            self.moneyLabel.font                = UIFont.systemFont(ofSize: 11, weight: .bold)
        }
    }
    
    func addCornerRound() {
        self.bgView.backgroundColor                 = .white
        self.bgView.layer.cornerRadius              = 7
        self.bgView.layer.masksToBounds             = true
        
        self.avaImageView.backgroundColor           = grayTitleColor
        self.avaImageView.layer.cornerRadius        = CGFloat(avaSize / 2)
        self.avaImageView.layer.masksToBounds       = true
        
        self.userLetterLabel.backgroundColor        = .clear
        self.userLetterLabel.layer.cornerRadius     = CGFloat(avaSize / 2)
        self.userLetterLabel.layer.masksToBounds    = true
    }
}
