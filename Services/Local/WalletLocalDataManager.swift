//
//  WalletLocalDataManager.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

class WalletLocalDataManager: WalletLocalDataManagerInput {
    
    func updateUserProfileModel(_ userProfile: PONSOUserProfile) {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        
        var retrievedProfile: UserProfile?
        
        do {
            let result = try context.fetch(UserProfile.fetchRequest())
            if let profile = result.first as? UserProfile {
                retrievedProfile = profile
            }
        } catch {
            return
        }
        
        retrievedProfile!.headIMG = userProfile.headIMG
        retrievedProfile!.echatAmount = userProfile.echatAmount
        retrievedProfile!.followers = userProfile.followers
        retrievedProfile!.following = userProfile.following
        retrievedProfile!.shots = userProfile.shots
        retrievedProfile!.nickName = userProfile.nickName
        retrievedProfile!.email = userProfile.email
        retrievedProfile!.url = userProfile.url
        retrievedProfile!.caption = userProfile.caption
        retrievedProfile!.address = userProfile.address
        
        do {
            try context.save()
        } catch {
            return
        }
        
    }
}
