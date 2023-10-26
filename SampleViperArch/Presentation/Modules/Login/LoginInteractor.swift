//
//  LoginInteractor.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-25.
//

import Alamofire
import SwiftyJSON

protocol PresenterToInteractorLoginProtocol: AnyObject {
    var presenter:InteractorToPresenterLoginProtocol? {get set}
    func callApi(email: String, password: String)
}

class LoginInteractor: PresenterToInteractorLoginProtocol{
    
    
    var presenter: InteractorToPresenterLoginProtocol?
    
    func callApi(email: String, password: String) {
        SwiftLoader.show(animated: true)
        if let receivedEmailData = KeyChain.load(key: "userEmail") {
            let storedEmail = receivedEmailData.to(type: String.self)
            if let receivedPasswordData = KeyChain.load(key: "userPassword") {
                let storedPassword = receivedPasswordData.to(type: String.self)
                if email == storedEmail && password == storedPassword {
                    self.presenter?.loginApiSuccess(data: LoginModel())
                } else {
                    self.presenter?.loginApiError(errMsg: "Wrong credentials")
                }
            }
        }
        
    }
    
    
}
