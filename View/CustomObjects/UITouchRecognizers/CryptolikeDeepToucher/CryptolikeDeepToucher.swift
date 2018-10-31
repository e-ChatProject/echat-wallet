//
//  CLButton.swift
//  e-Chat
//
//  Created by Rostyslav Gress on 13.06.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox
import UIKit.UIGestureRecognizerSubclass

class CryptolikeDeepToucher: UIGestureRecognizer {
    var vibrateOnDeepPress = true
    var threshold:CGFloat = 0.75
    var hardTriggerMinTime: TimeInterval = 0.5
    
    private var deepPressed: Bool = false
    private var deepPressedAt: TimeInterval = 0
    private var k_PeakSoundID: UInt32 = 1519
    private var hardAction: Selector?
    private var target: AnyObject?
    
    required init(target: AnyObject?, action: Selector, hardAction: Selector?=nil, threshold: CGFloat = 0.75) {
        self.target = target
        self.hardAction = hardAction
        self.threshold = threshold
        
        super.init(target: target, action: action)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            handleTouch(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        
        state = deepPressed ? UIGestureRecognizerState.ended : UIGestureRecognizerState.failed
        
        if state == UIGestureRecognizerState.ended {
            NotificationCenter.default.post(name: NSNotification.Name("criptolikeLongPressDidEnded"), object: nil)
        }
        deepPressed = false
    }
    
    private func handleTouch(touch: UITouch) {
        guard let _ = view, touch.force != 0 && touch.maximumPossibleForce != 0 else {
            return
        }
        
        let forcePercentage = (touch.force / touch.maximumPossibleForce)
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        
        if !deepPressed && forcePercentage >= threshold {
            state = UIGestureRecognizerState.began
            
            if vibrateOnDeepPress {
                AudioServicesPlaySystemSound(k_PeakSoundID)
            }

            deepPressedAt = NSDate.timeIntervalSinceReferenceDate
            deepPressed = true
        } else if deepPressed && forcePercentage <= 0 {
            endGesture()
        } else if deepPressed && currentTime - deepPressedAt > hardTriggerMinTime && forcePercentage == 1.0 {
            endGesture()
            
            if vibrateOnDeepPress {
                AudioServicesPlaySystemSound(k_PeakSoundID)
            }
            
            //fire hard press
            if let hardAction = self.hardAction, let target = self.target {
                target.perform(hardAction, with: self)
            }
        }
    }
    
    func endGesture() {
        state = UIGestureRecognizerState.ended
        deepPressed = false
    }
}

// MARK: DeepPressable protocol extension
protocol DeepPressable {
    
    var gestureRecognizers: [UIGestureRecognizer]? {get set}
    
    func addGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    func removeGestureRecognizer(gestureRecognizer: UIGestureRecognizer)
    
    func setDeepPressAction(target: AnyObject, action: Selector)
    func removeDeepPressAction()
}

extension DeepPressable {
    
    func setDeepPressAction(target: AnyObject, action: Selector) {
        let deepPressGestureRecognizer = CryptolikeDeepToucher(target: target, action: action, threshold: 0.75)
        
        self.addGestureRecognizer(gestureRecognizer: deepPressGestureRecognizer)
    }
    
    func removeDeepPressAction() {
        guard let gestureRecognizers = gestureRecognizers else {
            return
        }
        
        for recogniser in gestureRecognizers where recogniser is CryptolikeDeepToucher {
            removeGestureRecognizer(gestureRecognizer: recogniser)
        }
    }
}
