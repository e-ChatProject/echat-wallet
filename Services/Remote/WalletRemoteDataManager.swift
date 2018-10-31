//
//  WalletRemoteDataManager.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

class WalletRemoteDataManager: WalletRemoteDataManagerInput {

    var remoteRequestHandler: WalletRemoteDataManagerOutput?
    
    func loadMerchantAddressInManager() {
        let token       = UserLoginClient.sharedInstance.userProfile!.token
        let endPoint    = Endpoints.getReceiveAddress(token: token, parameters: nil, page: nil, pagesize: nil)
        
        WocaiNetworkClient().request(endpoint: endPoint, onCompletion: { (endp, responce) in
            if let responceValues = responce as? [String : Any] {
                do {
                    let data: Data  = try JSONSerialization.data(withJSONObject: responceValues, options: .prettyPrinted)

                    var addressString: String = ""                    
                    do {
                        let parsedValues = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        addressString = parsedValues!["address"] as! String
                    } catch {
                        print(error.localizedDescription)
                    }

                    if !addressString.isEmpty {
                        self.remoteRequestHandler?.addressDidLoad(addressString)
                    }
                } catch {
                    self.remoteRequestHandler?.addressDidLoadError("Empty value")
                }
            } else {
                self.remoteRequestHandler?.addressDidLoadError("Unknown object")
            }
        }, onError: { (endp, error) in
            self.remoteRequestHandler?.addressDidLoadError(error.localizedDescription)
        })
    }

    func loadAccountTransactionsInManager() {
        let token       = UserLoginClient.sharedInstance.userProfile!.token
        let endPoint    = Endpoints.getUserTransactions(token: token, parameters: nil, page: "1", pagesize: "200")
        
        WocaiNetworkClient().request(endpoint: endPoint, onCompletion: { (endp, responce) in
            if let listValues = responce as? [Dictionary<String, Any>] {
                do {
                    let data: Data  = try JSONSerialization.data(withJSONObject: listValues, options: .prettyPrinted)

                    do {
                        let parsedArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Dictionary<String, Any>]
                        if parsedArray!.count > 0 {
                            DispatchQueue.global(qos: .userInitiated).async {
                                let transactionsArray: [[Dictionary<String, Any>]] = Array<Any>.prepareTransactions(parsedArray!)
                                
                                DispatchQueue.main.async {
                                    self.remoteRequestHandler?.transactionsDidLoad(transactionsArray)
                                }
                            }
                        }
                    } catch {
                        self.remoteRequestHandler?.transactionsDidLoadError(error.localizedDescription)
                    }
                } catch {
                    self.remoteRequestHandler?.transactionsDidLoadError("Empty value")
                }
            } else {
                self.remoteRequestHandler?.transactionsDidLoadError("Unknown object")
            }
        }, onError: { (endp, error) in
            self.remoteRequestHandler?.transactionsDidLoadError(error.localizedDescription)
        })
    }
    
    func loadContactsListInManager() {
        let getFriendListEndpoint = Endpoints.getFriendList(token: UserLoginClient.sharedInstance.userProfile?.token, page: nil, pagesize: nil)
        WocaiNetworkClient().request(endpoint: getFriendListEndpoint, onCompletion: { (endpoint, response) in
            
            guard let response = response as? [Any] else {
                self.remoteRequestHandler?.contactsListDidLoadError("Server internal error".localized())
                return
            }
            
            var friendList: [PONSOFriendProfile] = [PONSOFriendProfile]()
            for friend in response {
                let jsonData = try! JSONSerialization.data(withJSONObject: friend, options: .prettyPrinted)
                let ponsoFriendProfile = try! JSONDecoder().decode(PONSOFriendProfile.self, from: jsonData)
                friendList.append(ponsoFriendProfile)
            }
            
            friendList = friendList.sorted(by: {$0.nickName.compare($1.nickName) == .orderedDescending })
            
            self.remoteRequestHandler?.contactsListDidLoad(friendList)
            
        }) { (endpoint, error) in
            self.remoteRequestHandler?.contactsListDidLoadError(error.errorDescription!)
        }
    }
    
    func sendTransferInManager(_ userID: String, with amount: String) {
        let sendTransferEndpoint = Endpoints.sendTransfer(page: nil, pagesize: nil, token: UserLoginClient.sharedInstance.userProfile?.token, userID: userID, amountToSend: amount)
        
        WocaiNetworkClient().request(endpoint: sendTransferEndpoint, onCompletion: { (endpoint, response) in
            let successTitle = "WalletTransactionSuccess".localized(using: "WalletLocalizable")
            
            self.remoteRequestHandler?.transferDidSend(successTitle)
        }) { (endpoint, error) in
            var errorMessage = "WalletTransactionFailed".localized(using: "WalletLocalizable")
            
            if error.errorDescription == "未设置交易密码" {
                errorMessage = "未设置交易密码".localized(using: "WalletLocalizable")
            }
            
            self.remoteRequestHandler?.transferDidSendError(errorMessage)
        }
    }
    
    func sendWithdrawInManager(_ address: String, with amount: String) {
        let sendWithdrawEndpoint = Endpoints.sendWithdrawTransaction(token: UserLoginClient.sharedInstance.userProfile?.token, page: nil, pagesize: nil, address: address, amountToSend: amount)
        
        WocaiNetworkClient().request(endpoint: sendWithdrawEndpoint, onCompletion: { (endpoint, response) in
            let successTitle = "WalletTransactionSuccess".localized(using: "WalletLocalizable")
            
            self.remoteRequestHandler?.transferDidSend(successTitle)
        }) { (endpoint, error) in
            var errorMessage = "WalletTransactionFailed".localized(using: "WalletLocalizable")
            
            if error.errorDescription == "未设置交易密码" {
                errorMessage = "未设置交易密码".localized(using: "WalletLocalizable")
            }
            
            self.remoteRequestHandler?.transferDidSendError(errorMessage)
        }
    }
    
    func updateUserInfo() {
        let getuserInfoEndpoint = Endpoints.getUserInfo(token: UserLoginClient.sharedInstance.userProfile?.token, page: nil, pagesize: nil)
        WocaiNetworkClient().request(endpoint: getuserInfoEndpoint, onCompletion: { (endpoint, response) in
            
            var userProfile: PONSOUserProfile?
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
                userProfile = try JSONDecoder().decode(PONSOUserProfile.self, from: jsonData)
            } catch {
                self.remoteRequestHandler?.userProfileUpdatedError("Could not ")
            }
            
            if userProfile != nil {
                self.remoteRequestHandler?.userProfileWasUpdated(userProfile!)
            }
            
        }) { (endpoint, error) in
            self.remoteRequestHandler?.userProfileUpdatedError(error.localizedDescription)
        }
    }
    
    func getCryptoLikeDetailsInManager(_ dynamicId: String) {
        let sendWithdrawEndpoint = Endpoints.getMomentDetails(token: UserLoginClient.sharedInstance.userProfile?.token, page: nil, pagesize: nil, dynamicId: dynamicId)
        
        WocaiNetworkClient().request(endpoint: sendWithdrawEndpoint, onCompletion: { (endpoint, response) in
            let jsonData = try! JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            let ponsoMoment = try! JSONDecoder().decode(PONSOMoment.self, from: jsonData)
            
            self.remoteRequestHandler?.cryptolikeDetailsDidReceived(ponsoMoment)
        }) { (endpoint, error) in
            var errorMessage = "WalletTransactionFailed".localized(using: "WalletLocalizable")
            
            if error.errorDescription == "未设置交易密码" {
                errorMessage = "未设置交易密码".localized(using: "WalletLocalizable")
            }
            
            self.remoteRequestHandler?.cryptolikeDetailsDidReceivedError(errorMessage)
        }
    }
}
