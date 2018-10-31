//
//  WalletSendView.swift
//  e-Chat
//
//  Created by Rostyslav on 4/20/18.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import UIKit


class WalletSendView: WalletBaseView {
    @IBOutlet weak var withdrawButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var findContactButton: UIButton!
    @IBOutlet weak var sendMoneyLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var ethLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var middleLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var withdrawButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var withdrawButtonBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButtonBottomMarginConstraint: NSLayoutConstraint!
    weak var sendDelegate: WalletSendViewDelegate!
    var contactsCollectionView: UICollectionView!
    var contactsList: [PONSOFriendProfile] = []
    var originContactsList: [PONSOFriendProfile] = []
    var selectedContact: PONSOFriendProfile!

    
    override func addCustomizations() {
        self.topLine.backgroundColor    = graySeparatorColor
        self.middleLine.backgroundColor = graySeparatorColor
        self.bottomLine.backgroundColor = graySeparatorColor
        
        self.withdrawButton.addStyleForBottomLetButton(with: "WalletWithdraw", in: "WalletLocalizable")
        
        self.findContactButton.setTitle("WalletFindContact".localized(using: "WalletLocalizable"), for: .normal)
        self.findContactButton.setTitle("WalletFindContact".localized(using: "WalletLocalizable"), for: .highlighted)
        self.findContactButton.setTitleColor(leftBlueColor, for: .normal)
        self.findContactButton.setTitleColor(leftBlueColor, for: .highlighted)
        
        self.sendMoneyLabel.text      = "WalletSendMoney".localized(using: "WalletLocalizable")
        self.sendMoneyLabel.textColor = grayTitleColor

        self.toLabel.text      = String.init(format:"%@:", "WalletTo".localized(using: "WalletLocalizable"))
        self.toLabel.textColor = leftBlueColor

        self.ethLabel.text      = String.init(format:"%@:", "ECHT".localized(using: "WalletLocalizable"))
        self.ethLabel.textColor = leftBlueColor
        
        addDoneButtonToNumberPad()

        self.accountTextField.placeholder   = "WalletUserHolder".localized(using: "WalletLocalizable")
        self.amountTextField.placeholder     = "WalletAmountHolder".localized(using: "WalletLocalizable")

        self.accountTextField.textColor         = grayTitleColor        // Account info set on this label
        self.amountTextField.textColor           = grayTitleColor        // Number for send
        
        self.accountTextField.clearButtonMode   = UITextFieldViewMode.whileEditing
        self.amountTextField.clearButtonMode     = UITextFieldViewMode.whileEditing
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection          = .horizontal
        flowLayout.itemSize                 = CGSize(width:UIScreen.main.bounds.size.width, height:80)
        flowLayout.minimumLineSpacing       = 5
        flowLayout.minimumInteritemSpacing  = 10
        
        self.contactsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.contactsCollectionView.register(WalletFriendCell.self, forCellWithReuseIdentifier: friendCellId)
        self.contactsCollectionView.register(WalletAddFriendCell.self, forCellWithReuseIdentifier: addFriendCellId)
        self.contactsCollectionView.delegate                        = self
        self.contactsCollectionView.dataSource                      = self
        self.contactsCollectionView.backgroundColor                 = .clear
        self.contactsCollectionView.showsHorizontalScrollIndicator  = false

        self.addSubview(self.contactsCollectionView)
        
        let childView         = ["collectionView": self.contactsCollectionView]
        let childViewsFormats = ["H:|[collectionView]|",
                                 "V:|-(26)-[collectionView(80)]"]
        addConstraints(for:childView as! [String : UIView], with:childViewsFormats, to:self)
        
        if modelName != "iPhone X" {
            self.withdrawButtonBottomMarginConstraint.constant  = 65
            self.nextButtonBottomMarginConstraint.constant      = 65
        }
        
        self.nextButton.addStyleForBottomRightButton(with: "WalletNext", in: "WalletLocalizable")
    }
    
    func addDoneButtonToNumberPad() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:50))
        doneToolbar.barStyle = .default
        
        let spaceItem = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let doneItem: UIBarButtonItem = UIBarButtonItem(title: "Done".localized(), style: .done, target: self, action: #selector(self.doneButtonTapped))
        
        var toolbarItems = [UIBarButtonItem]()
        toolbarItems.append(spaceItem)
        toolbarItems.append(doneItem)
        
        doneToolbar.items = toolbarItems
        doneToolbar.sizeToFit()
        
        self.amountTextField.inputAccessoryView = doneToolbar
    }
    
    func changeSendWidthButtons() {
        self.withdrawButtonWidthConstraint.constant = bottomButtonsWidth
        self.nextButtonWidthConstraint.constant     = bottomButtonsWidth
    }
    
    func fillContacts(_ list: [PONSOFriendProfile]) {
        self.originContactsList = list
        self.contactsList       = list
        
        self.contactsCollectionView.reloadData()
    }
    
    func findContact(by type: Int, and text: String) {
        self.contactsList = self.originContactsList
        var foundContacts: [PONSOFriendProfile] = []
        
            switch type {
                case ContactSearchTypes.nickName.rawValue:
                    foundContacts = self.contactsList.filter {
                        $0.nickName.lowercased().contains(text.lowercased())
                    }
                case ContactSearchTypes.userName.rawValue:
                    foundContacts = self.contactsList.filter {
                        $0.userName.lowercased().contains(text.lowercased())
                    }
                default:
                    break
            }
        
        refreshContacts(from: foundContacts)
    }
    
    func refreshContacts(from contacts: [PONSOFriendProfile]) {
        self.contactsList = contacts

        self.contactsCollectionView.reloadData()
    }
    
    func cleanInputFields() {
        self.accountTextField.text = ""
        self.amountTextField.text  = ""
    }
    
    func accountFieldNextAction() {
        let amountString: String = self.amountTextField.text!
        if !amountString.isEmpty {
            self.accountTextField.resignFirstResponder()
        } else {
            self.amountTextField.becomeFirstResponder()
        }
    }

    func fillAccountField(by tag: Int) {
        if self.contactsList.count > 0 {
            self.selectedContact        = self.contactsList[tag]
            
            self.accountTextField.text  = self.selectedContact.nickName
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                self.accountFieldNextAction()
            }
        } else {
            print("Empty contacts list")
        }
    }
    
    func openAmountTextField() {
        self.amountTextField.text  = ""
        self.amountTextField.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        self.accountTextField.resignFirstResponder()
        self.amountTextField.resignFirstResponder()
    }
    
    func cleanAllStates() {
        self.selectedContact        = nil
        self.accountTextField.text  = ""
        self.amountTextField.text   = ""
        self.contactsList           = []
        self.originContactsList     = []
    }

    @objc func doneButtonTapped() {
        hideKeyboard()
    }
    
    @objc func contactButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func withdrawButtonTapped(_ sender: UIButton) {
        hideKeyboard()
        sendDelegate?.walletWithdrawButtonTapped()
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        hideKeyboard()
        sendDelegate?.walletNextButtonTapped(self.selectedContact)
    }
}

protocol WalletSendViewDelegate:class {
    func walletWithdrawButtonTapped()
    func walletNextButtonTapped(_ contact: PONSOFriendProfile?)
    func walletAddFriendButtonTapped()
}
