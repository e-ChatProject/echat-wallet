//
//  CryptolikeZoomedView.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 13.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


class CriptolikeZoomedView: ZoomedView {
    
    @IBOutlet weak var avaImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userLetterLabel: UILabel!
    @IBOutlet weak var userTitleLabel: UILabel!
    var bgView: UIView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        backgroundColor = UIColor.clear
        
        bgView                  = loadNib()
        bgView.frame            = bounds
        bgView.backgroundColor  = bgViewColor
        
        addSubview(bgView)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": bgView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": bgView]))
        
        addCustomizations()
    }
    
    func addCustomizations() {
        self.layer.cornerRadius              = CGFloat(10)
        self.clipsToBounds                   = true
        
        self.backgroundColor                 = .white

        self.avaImageView.layer.cornerRadius = self.avaImageView.bounds.size.width / 2.0
        self.avaImageView.clipsToBounds      = true
    }
    
    func setUserTitle(_ title: String) {
        if !title.isEmpty {
            self.userTitleLabel.text = title
        }
    }
    
    func setViewsValues(by values: [String: Any]) {
        if let userHash = values["touserid"] as? String {
            self.avaImageView.image = UIImage(named: "gradient\(abs(userHash.hashValue) % 10)")
        }
        
        if let userName = values["tousernickname"] as? String {
            setUserTitle(userName)
        }
        
        self.userLetterLabel.isHidden = true
        
        self.avaImageView.af_cancelImageRequest()
        if let image = values["toUserHeadImg"] as? String {
            if !image.isEmpty {
                if let url = URL(string: AppStringDefines.bucketImagePrefix.rawValue + image) {
                    self.avaImageView.af_setImage(withURL: url)
                }
            } else {
                self.userLetterLabel.isHidden = false
                if let toUser = values["tousernickname"] as? String {
                    if let userLetter = toUser.uppercased().first {
                        self.userLetterLabel.text = String(userLetter)
                    }
                }
            }
        }
        
        self.postImageView.af_cancelImageRequest()
        if let image = values["image"] as? String {
            if !image.isEmpty {
                if let url = URL(string: AppStringDefines.bucketImagePrefix.rawValue + image) {
                    
                    self.postImageView.af_setImage(withURL: url,
                                                   placeholderImage: nil,
                                                   filter: nil,
                                                   imageTransition: .crossDissolve(0.5),
                                                   completion: { [unowned self] response in
                                                    if let error = response.result.error {
                                                        print(error.localizedDescription)
                                                    } else {
                                                        let receivedImage: UIImage  = response.result.value!
                                                        
                                                        var zoomedViewHeight    = receivedImage.size.height * 2
                                                        let screenHeight        = UIScreen.main.bounds.size.height
                                                        if zoomedViewHeight > (screenHeight - 200) {
                                                            zoomedViewHeight = screenHeight - 200
                                                        }

                                                        self.heightConstraint.constant = zoomedViewHeight
                                                    }
                    })
                }
            }
        }
    }
}
