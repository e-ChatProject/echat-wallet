//
//  WalletViewCryptolikeCell.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 08.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class WalletViewCryptolikeCell: WalletBaseCell {

    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
 
        addCustomizations()
        
        let textContainer: UIView = createFilledTextContainer()
        
        let childViews = ["ava":     self.avaImageView,
                          "clike":   self.cryptlikeImageView,
                          "text":    textContainer,
                          "money":   self.moneyLabel,
                          "letter":  self.userLetterLabel]
        
        let childViewsConstraints: [String] = [String.init(format: "H:|-(%d)-[ava(%d)]", rightMargin, avaSize),
                                               String.init(format: "V:[ava(%d)]", avaSize),
                                               String.init(format: "H:|-(60)-[text(%d)]", textWidth),
                                               "V:[text(48)]",
                                               "V:[money(15)]",
                                               String.init(format: "H:[money(90)]-(10)-[clike(55)]-(%d)-|", rightMargin),
                                               String.init(format: "V:[clike(55)]", rightMargin),
                                               String.init(format: "H:|-(%d)-[letter(%d)]", rightMargin, avaSize),
                                               String.init(format: "V:|-(%d)-[letter(%d)]", rightMargin, avaSize)]
        
        addSubviews(childViews, to:self.bgView, with:childViewsConstraints)
        
        addCenterY(to: self.bgView, for: self.avaImageView)
        addCenterY(to: self.bgView, for: textContainer)
        addCenterY(to: self.bgView, for: self.moneyLabel)
        addCenterY(to: self.bgView, for: self.cryptlikeImageView)

        let childBgView = ["bgView":     self.bgView]
        let childBgViewConstraints: [String] = ["H:|[bgView]|",
                                                "V:|-(5)-[bgView]-(5)-|"]
        addSubviews(childBgView, to:contentView, with:childBgViewConstraints)
        
        contentView.layoutIfNeeded()
    }
    
    func addCustomizations() {
        self.backgroundColor                        = .clear
        contentView.backgroundColor                 = .clear
        
        self.cryptlikeImageView.contentMode         = .scaleAspectFill
        self.cryptlikeImageView.clipsToBounds       = true
        self.cryptlikeImageView.backgroundColor     = .clear
        self.cryptlikeImageView.layer.cornerRadius  = 7
        self.cryptlikeImageView.layer.masksToBounds = true

        self.echtTitleLabel.textColor       = .black
        
        self.nameLabel.textColor            = .black
        
        self.dateLabel.textColor            = grayTitleColor
        
        self.moneyLabel.textAlignment       = .right
        
        addFontAdaptations()
        
        addCornerRound()
    }
    
    func setCellValues(by values: [String: Any]) {
        var directionTitle: String      = ""
        var moneyAction: String         = ""
        
        self.avaImageView.af_cancelImageRequest()
        if let image = values["toUserHeadImg"] as? String {
            if !image.isEmpty {
                let url = AppStringDefines.bucketImagePrefix.rawValue + image
                
                if let userHash = values["touserid"] as? String {
                    let placeholderImage = UIImage(named: "gradient\(abs(userHash.hashValue) % 10)")
                    
                    self.avaImageView.loadAsyncFrom(url: url, placeholder: placeholderImage)
                    
                } else {
                    self.avaImageView.loadAsyncFrom(url: url, placeholder: nil)
                }
            } else {
                self.userLetterLabel.isHidden = false
                if let userHash = values["touserid"] as? String {
                    self.avaImageView.image = UIImage(named: "gradient\(abs(userHash.hashValue) % 10)")
                }
                
                if let toUser = values["tousernickname"] as? String {
                    if let userLetter = toUser.uppercased().first {
                        self.userLetterLabel.text = String(userLetter)
                    }
                }
            }
        } else {
            if let userHash = values["touserid"] as? String {
                self.avaImageView.image = UIImage(named: "gradient\(abs(userHash.hashValue) % 10)")
            }
        }
        
        if let actionType = values["transtype"] as? String {
            let type: Int = Int(actionType)!
            switch type {
                case TransactionTypes.ReceivedType.rawValue:
                    directionTitle              = "WalletContactFrom".localized(using: "WalletLocalizable")
                    moneyAction                 = "+"
                    self.moneyLabel.textColor   = leftBlueColor
                case TransactionTypes.SentType.rawValue:
                    directionTitle              = "WalletContactTo".localized(using: "WalletLocalizable")
                    moneyAction                 = "-"
                    self.moneyLabel.textColor   = rightPurpleColor
                default:
                    break
            }
        }
        
        let transactionTitle: String    = "ECHT".localized(using: "WalletLocalizable")
        self.echtTitleLabel.text        = String.init(format:"%@ %@", transactionTitle, directionTitle)
    
        if let toUser = values["tousernickname"] as? String {
            self.nameLabel.text = toUser
        }
        
        if let money = values["money"] as? String {
            let moneyValue: Double = Double(money)!
            if moneyValue == 0.0 {
                self.moneyLabel.text = String.init(format:"%.1f %@", moneyValue, "ECHT".localized(using: "ProfileLocalizable"))
            } else {
                self.moneyLabel.text = String.init(format:"%@ %.2f %@", moneyAction, moneyValue, "ECHT".localized(using: "ProfileLocalizable"))
            }
        }
        
        if let date = values["finishdate"] as? Int32 {
            let dateString = String.detectContactDay(from: date)
            
            self.dateLabel.text = dateString
        }
        
        self.cryptlikeImageView.image = nil
        self.avaImageView.af_cancelImageRequest()
        if let image = values["image"] as? String {
            if !image.isEmpty {
                let url =  URL(string: AppStringDefines.bucketImagePrefix.rawValue + image)
                
                self.cryptlikeImageView.af_setImage(withURL: url!,
                                                        placeholderImage: nil,
                                                        filter: nil,
                                                        imageTransition: .crossDissolve(0.5),
                                                        completion: { [unowned self] response in
                                                            if let error = response.result.error {
                                                                print(error.localizedDescription)
                                                            } else {
                                                                self.cropCryptoImage(response.result.value!)
                                                                self.cryptlikeImageView.isHidden = false
                                                            }
                    })
            }
        } else if let video = values["video"] as? String {
            if !video.isEmpty {
                if let url = URL(string: AppStringDefines.bucketImagePrefix.rawValue + video) {
                    if let firstFrameImage = getThumbnail(by: url) {
                        self.cryptlikeImageView.image = firstFrameImage
                        // self.cropCryptoImage()
                        self.cryptlikeImageView.isHidden = false
                    }
                }
            }
        }
    }
    
    func getThumbnail(by path: URL) -> UIImage? {
        do {
            
            let asset = AVURLAsset(url: path , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func cropCryptoImage(_ image: UIImage) {
        var criptoImage: UIImage     = UIImage().cropToSquare(image)
        
        let criptoImageSize: CGSize  = self.cryptlikeImageView.frame.size
        criptoImage = UIImage().cropToBounds(image: criptoImage, width: Double(criptoImageSize.width), height: Double(criptoImageSize.height))
        self.cryptlikeImageView.image  = criptoImage
    }
    
    func isNotEmptyEchtContent(in values: [String: Any]) -> Bool {
        if let image = values["image"] as? String {
            if !image.isEmpty {
                return true
            }
        }
        
        if let video = values["video"] as? String {
            if !video.isEmpty {
                return true
            }
        }
        
        return false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
