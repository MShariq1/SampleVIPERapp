//
//  HomeRouter.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-12.
//

import UIKit

protocol PresenterToRouterHomeProtocol: AnyObject {
    static func createModule() -> HomeView
    func pushToHome(navigationConroller:UINavigationController)
}

class HomeRouter: PresenterToRouterHomeProtocol {
     
    static func createModule() -> HomeView {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "HomeView") as! HomeView
        
        let presenter: ViewToPresenterHomeProtocol & InteractorToPresenterHomeProtocol = HomePresenter()
        let interactor: PresenterToInteractorHomeProtocol = HomeInteractor()
        let router:PresenterToRouterHomeProtocol = HomeRouter()
        
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
