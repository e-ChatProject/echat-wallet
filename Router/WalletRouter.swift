//
//  WalletRouter.swift
//  e-Chat
//
//  Created by Nikolay Avilov on 20.04.2018.
//  Copyright © 2018 CryptoPark. All rights reserved.
//

import Foundation

class WalletRouter: WalletRouterInput {
    

    static func createWalletModule() -> UIViewController {
        let navigationController = storyboard.instantiateViewController(withIdentifier: "WalletNavigationController")
        
        if let view = navigationController.childViewControllers.first as? WalletView {
            let presenter: WalletInteractorOutput & WalletViewOutput = WalletPresenter()
            let interactor: WalletInteractorInput & WalletRemoteDataManagerOutput = WalletInteractor()
            let remoteDataManager: WalletRemoteDataManagerInput = WalletRemoteDataManager()
            let localDataManager: WalletLocalDataManagerInput = WalletLocalDataManager()
            let router: WalletRouterInput = WalletRouter()
            
            presenter.view = view
            presenter.interactor = interactor
            presenter.router = router
            view.presenter = presenter
            interactor.presenter = presenter
            interactor.remoteDataManager = remoteDataManager
            interactor.localDataManager = localDataManager
            remoteDataManager.remoteRequestHandler = interactor

            return navigationController
        }
        
        return UIViewController()
    }
    
    static var storyboard: UIStoryboard = {
        return UIStoryboard(name: "WalletStoryboard", bundle: .main)
    }()

    func presentQRScanner(fromView: WalletViewInput, output: QRScannerModuleOutput) {
        let qrScannerViewController = QRScannerRouter.createQRScannerModule(outputModule: output)
        
        if let sourceView = fromView as? UIViewController {
            sourceView.navigationController?.pushViewController(qrScannerViewController, animated: true)
            sourceView.title = "ECHT".localized(using: "WalletLocalizable")
        }
    }
    
    func presentAlert(from view: WalletView) {
        
    }
    
    func showPin(on view: UIViewController?, with presenter: WalletViewOutput) {
        let wrapper = SensitiveDataWrapper()
        if wrapper.isPinCodeSet() {
            if let viewController = view {
                showPinViewController(.payment, from: viewController, with: presenter)
            }
        } else {
            if let viewController = view {
                let alert = UIAlertController(title: "Message".localized(using: "ProfileLocalizable"), message: "WalletSetPinMessage".localized(using: "WalletLocalizable"), preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { [unowned self] (action) in
                    self.showPinViewController(.setPin, from: viewController, with: presenter)
                }))
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func showPinViewController(_ type: PinLockScreenType, from vc: UIViewController, with output: WalletViewOutput) {
        let pinView = PinLockRouter.createPinLockSreen(type: type, output: output as! PinLockModuleOutput)
        vc.present(pinView, animated: true, completion: nil)
    }
    
    func presentAddContact(from wallet: WalletViewInput, with output: AddContactModuleOutput) {
        let addContactViewController = AddContactRouter.createAddContactModule(with: output)

        if let sourceView = wallet as? UIViewController {
            sourceView.navigationController?.isNavigationBarHidden = false
            
            sourceView.navigationController?.pushViewController(addContactViewController, animated: true)
        }
    }
    
    func showUserProfile(from wallet: WalletViewInput, userID: String) {
        if let sourceView = wallet as? UIViewController {
            let loggedUserID = UserLoginClient.sharedInstance.userProfile!.id
            
            if userID == loggedUserID {
                let navigationController = MyProfileRouter.createMyProfileModule()
                if let view = navigationController.childViewControllers.first as? MyProfileView {
                    sourceView.navigationController?.isNavigationBarHidden = false
                    sourceView.navigationController?.pushViewController(view, animated: true)
                }
            } else {
                sourceView.navigationController?.isNavigationBarHidden = false
                sourceView.navigationController?.pushViewController(UserProfileRouter.createUserProfileModule(userID), animated: true)
            }
        }
    }
    
    func showDetailsPost(from wallet: WalletViewInput, and post: PONSOMoment, output: MomentInfoModuleOutput) {
        let detailsController = MomentInfoRouter.createMomentInfoModule(post, output: output)
        if let sourceView = wallet as? UIViewController {
            sourceView.navigationController?.isNavigationBarHidden = false
            sourceView.navigationController?.pushViewController(detailsController, animated: true)
        }
    }

}

