//
//  WalletSendView+TextFieldDelegate.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 08.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation


extension WalletSendView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
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
        
        if textField.tag == 0 && self.originContactsList.count > 0 {
            var searchString: String = textField.text!
            
            let receivedChar = string.cString(using: String.Encoding.utf8)!
            let isBackspace  = strcmp(receivedChar, "\\b")
            
            if isBackspace == -92 {
                searchString.remove(at: searchString.index(before: searchString.endIndex))
                
                if searchString.count == 0 {
                    refreshContacts(from: self.originContactsList)
                }
            } else {
                if !searchString.isEmpty {
                    if range.location == 0 {
                        searchString = string + searchString
                    } else {
                        searchString.insert(Character(string), at: searchString.index(searchString.startIndex, offsetBy: range.location))
                    }
                } else {
                    searchString = string
                }
            }
            
            let numbersSet          = CharacterSet.decimalDigits
            let charactersSet       = CharacterSet(charactersIn: searchString)
            let isUserNameSearch    = numbersSet.isSuperset(of: charactersSet)
            
            if !searchString.isEmpty {
                if isUserNameSearch == true {   //Search by userName
                    findContact(by: ContactSearchTypes.userName.rawValue, and: searchString)
                } else {                        //Search by nickName
                    findContact(by: ContactSearchTypes.nickName.rawValue, and: searchString)
                }
            }
        }
        
        if textField.tag == 1 {
            let checkResult: Bool = textField.checkWalletAmount(by: string)
            return checkResult
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.text = ""
        
        if textField.tag == 0 {
            if textField.text!.isEmpty {
                refreshContacts(from: self.originContactsList)
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag > 0 {
            textField.resignFirstResponder()
        } else {
            accountFieldNextAction()
        }
        return true
    }
}
