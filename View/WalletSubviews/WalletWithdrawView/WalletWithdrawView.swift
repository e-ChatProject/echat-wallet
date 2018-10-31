//
//  WalletWithdrawView.swift
//  e-Chat
//
//  Created by Rostyslav on 4/25/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletWithdrawView: WalletBaseView {
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topSubtitleLabel: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var receiverView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var pasteButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pasteButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButtonWidthConstraint: NSLayoutConstraint!
    weak var withdrawDelegate: WalletWithdrawViewDelegate!
    
    
    override func addCustomizations() {
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        swipeGesture.direction = UISwipeGestureRecognizerDirection.down
        self.addGestureRecognizer(swipeGesture)
        
        self.confirmButton.addStyleForBottomLetButton(with: "WalletConfirm", in: "WalletLocalizable")
        
        self.topTitleLabel.text         = "WalletWithdraw".localized(using: "WalletLocalizable")
        self.topTitleLabel.textColor    = leftBlueColor
        self.topSubtitleLabel.text      = "WalletWithdrawSubtitle".localized(using: "WalletLocalizable")
        self.topSubtitleLabel.textColor = grayTitleColor
        
        addNextButtonToNumberPad()
        
        self.amountTextField.clearButtonMode = UITextFieldViewMode.whileEditing
        self.amountTextField.placeholder     = "WalletAmount".localized(using: "WalletLocalizable")
        self.receiverTextField.placeholder   = "WalletReceiver".localized(using: "WalletLocalizable")
        
        let editViews: [UIView] = [self.amountView, self.receiverView, self.amountTextField, self.receiverTextField]
        for view in editViews {
            addChanges(for: view, with: 10)
        }
    }
    
    @objc func dismissKeyboard(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            self.endEditing(true)
        }
    }
    
    func addNextButtonToNumberPad() {
        let nextToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        nextToolbar.barStyle = .default
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let nextItem: UIBarButtonItem = UIBarButtonItem(title: "Next".localized(), style: .done, target: self, action: #selector(self.nextButtonTapped))
        
        var toolbarItems = [UIBarButtonItem]()
        toolbarItems.append(spaceItem)
        toolbarItems.append(nextItem)
        
        nextToolbar.items = toolbarItems
        nextToolbar.sizeToFit()
        
        self.amountTextField.inputAccessoryView = nextToolbar
    }
    
    func changeWithdrawWidthButtons() {
        self.confirmButtonWidthConstraint.constant  = bottomButtonsWidth
    }
    
    @objc func nextButtonTapped() {
        if !self.receiverTextField.text!.isEmpty {
            self.amountTextField.resignFirstResponder()
        } else {
            self.receiverTextField.becomeFirstResponder()
        }
    }
    
    func addChanges(for view: UIView, with radius: CGFloat) {
        view.backgroundColor     = .white
        view.layer.cornerRadius  = radius
        view.layer.masksToBounds = true
        view.layer.borderWidth   = 1
        view.layer.borderColor   = UIColor.white.cgColor
    }
    
    func cleanInputFields() {
        self.receiverTextField.text = ""
        self.amountTextField.text   = ""
    }
    
    func checkReceiverField() {
        let resultString = self.receiverTextField.text!
        
        if resultString.hasPrefix("0") {
            self.receiverTextField.text = resultString
            self.pasteButton.setBgImageForAllStates(UIImage(named:"walletCleanButton")!)
            changePasteButtonConstraints(by:PasteButtonStates.cleanState.rawValue)
        } else {
            self.receiverTextField.text = ""
            self.pasteButton.setBgImageForAllStates(UIImage(named:"pasteAddressButton")!)
            changePasteButtonConstraints(by:PasteButtonStates.pasteState.rawValue)
            
            withdrawDelegate?.withdrawShowWrongReciverMessage()
        }
    }
    
    func changePasteButtonConstraints(by type: Int) {
        switch type {
            case PasteButtonStates.pasteState.rawValue:
                self.pasteButtonHeightConstraint.constant = 33
                self.pasteButtonWidthConstraint.constant  = 25
            case PasteButtonStates.cleanState.rawValue:
                self.pasteButtonWidthConstraint.constant  = 18
                self.pasteButtonHeightConstraint.constant = 18
            default:
                break
        }
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        self.endEditing(true)

        AdjustAnalyticsManager.shared.addTrackEvent(with: walletPushGive)
        
        withdrawDelegate?.withdrawConfirmButtonTapped()
    }
    
    @IBAction func pasteAddressButtonTapped(_ sender: UIButton) {
        self.endEditing(true)
        withdrawDelegate?.withdrawPasteAddressButtonTapped()
    }
}

protocol WalletWithdrawViewDelegate:class {
    func withdrawConfirmButtonTapped()
    func withdrawPasteAddressButtonTapped()
    func withdrawShowWrongReciverMessage()
}

extension WalletWithdrawView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let fieldString = textField.text!
        
        self.pasteButton.setBgImageForAllStates(UIImage(named:"pasteAddressButton")!)
        changePasteButtonConstraints(by:PasteButtonStates.pasteState.rawValue)

        switch textField.tag {
            case 0:
                if !fieldString.isEmpty {
                    if fieldString == "0" {
                        textField.text = ""
                    } else {
                        let amountValue: Double = Double(fieldString)!
                        if amountValue < 20 || amountValue > 99999 {
                            textField.text = ""
                        }
                    }
                }
            case 1:
                let isRightFistChar = fieldString.hasPrefix("0")
                if fieldString.count < 20 || fieldString.count > 70 || isRightFistChar == false {
                    textField.text = ""
                } else {
                    self.pasteButton.setBgImageForAllStates(UIImage(named:"walletCleanButton")!)
                    changePasteButtonConstraints(by:PasteButtonStates.cleanState.rawValue)
                }
            default:
                break
        }

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
            case 0:
                let checkResult: Bool = textField.checkWalletAmount(by: string)
                return checkResult
            case 1:
                var receiverString  = textField.text! + string
                receiverString      = receiverString.trimmingCharacters(in: .whitespaces)
                
                if receiverString.count > 0 {
                    self.pasteButton.setBgImageForAllStates(UIImage(named:"walletCleanButton")!)
                    changePasteButtonConstraints(by:PasteButtonStates.cleanState.rawValue)
                }
            default:
                break
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
