//
//  LoginRouter.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-25.
//

import UIKit

protocol PresenterToRouterLoginProtocol: AnyObject {
    static func createModule() -> LoginView
    func pushToHome(navigationConroller:UINavigationController)
}

class LoginRouter: PresenterToRouterLoginProtocol {
     
    static func createModule() -> LoginView {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "LoginView") as! LoginView
        
        let presenter: ViewToPresenterLoginProtocol & InteractorToPresenterLoginProtocol = LoginPresenter()
        let interactor: PresenterToInteractorLoginProtocol = LoginInteractor()
        let router:PresenterToRouterLoginProtocol = LoginRouter()
        
        view.presentor = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    static var mainstoryboard: UIStoryboard {
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToHome(navigationConroller navigationController:UINavigationController) {
        let convo = HomeRouter.createModule()
        navigationController.pushViewController(convo,animated: true)
    }
    
}
