//
//  LoginPresenter.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-25.
//
import UIKit

protocol InteractorToPresenterLoginProtocol: AnyObject {
    func loginApiSuccess(data: LoginModel)
    func loginApiError(errMsg: String)
}

protocol ViewToPresenterLoginProtocol: AnyObject{
    
    var view: PresenterToViewLoginProtocol? {get set}
    var interactor: PresenterToInteractorLoginProtocol? {get set}
    var router: PresenterToRouterLoginProtocol? {get set}
    func hitApi()
    func showHomeView(navigationController:UINavigationController)

}

class LoginPresenter:ViewToPresenterLoginProtocol {
    var view: PresenterToViewLoginProtocol?
    
    var interactor: PresenterToInteractorLoginProtocol?
    
    var router: PresenterToRouterLoginProtocol?
    
    func hitApi() {
        interactor?.callApi(email: "", password: "")
    }
    
    func showHomeView(navigationController: UINavigationController) {
        router?.pushToHome(navigationConroller:navigationController)
    }

}

extension LoginPresenter: InteractorToPresenterLoginProtocol{
    
    func loginApiSuccess(data: LoginModel) {
        view?.loginApiSuccess(data: data)
    }
    
    func loginApiError(errMsg: String) {
        view?.loginApiError(errMsg: errMsg)
    }
    
    
}
