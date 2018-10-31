//
//  WalletBaseView.swift
//  e-Chat
//
//  Created by Rostyslav on 4/25/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletBaseView: UIView {
    var bgView: UIView!
    let modelName = UIDevice.current.modelName
    
    
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

    }
}
