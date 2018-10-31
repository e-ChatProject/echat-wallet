//
//  WalletReceiveView.swift
//  e-Chat
//
//  Created by Rostyslav on 4/25/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletReceiveView: WalletBaseView {
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var hashLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var hashTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrImageHeightConstraint: NSLayoutConstraint!
    
    
    override func addCustomizations() {
        self.hashLabel.textColor = grayTitleColor
        
        self.copyButton.setTitle("WalletCopyHashButton".localized(using: "WalletLocalizable"), with:grayTitleColor)
        
        if modelName == "iPhone SE" {
            self.qrImageWidthConstraint.constant    = 160
            self.qrImageHeightConstraint.constant   = 160
            
            self.hashLabel.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.semibold)
        }
    }
    
    func changeTopMargin() {
        self.topMarginConstraint.constant       = 3
        self.hashTopMarginConstraint.constant   = 25
    }
    
    @IBAction func copyButtonTapped(_ sender: UIButton) {
        sender.isEnabled = false
        
        let hashCopy: String = self.hashLabel.text!

        if !(self.hashLabel.text?.isEmpty)! {
            self.hashLabel.alpha = 0
            
            UIView.transition(with: self.hashLabel,
                              duration: 1.0,
                              options: .transitionCrossDissolve,
                              animations: { [unowned self] in
                                    self.hashLabel.alpha = 1
                                    self.hashLabel.text  = "WalletCopied".localized(using: "WalletLocalizable")
                }, completion: { finished in
                    self.hashLabel.alpha = 0
                    
                    UIView.transition(with: self.hashLabel,
                                      duration: 1.0,
                                      options: .transitionCrossDissolve,
                                      animations: { [unowned self] in
                                        self.hashLabel.alpha = 1
                                        self.hashLabel.text = hashCopy
                        }, completion: { finished in
                            let pasteboard          = UIPasteboard.general
                            pasteboard.string       = hashCopy
                            
                            sender.isEnabled = true
                    })
            })
        }
    }
    
    func convertAddressToQr(_ address: NSString) {
        self.hashLabel.text = address as String

        self.qrImageView.image = UIImage.generateQRImage(stringQR: address, withSizeRate: CGFloat(1), andWidth: self.qrImageView.bounds.size.width)
    }
}
