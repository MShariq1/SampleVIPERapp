//
//  LoginView.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-25.
//

import UIKit

protocol PresenterToViewLoginProtocol: AnyObject {
    func loginApiSuccess(data: LoginModel)
    func loginApiError(errMsg: String)
}

class LoginView: UIViewController {
    
    @IBOutlet weak var btnViewPass: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var vuPassword: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var vuEmail: UIView!
    @IBOutlet weak var vuMain: UIView!
    
    var presentor: ViewToPresenterLoginProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func onViewPass(_ sender: Any) {
        btnViewPass.isSelected.toggle()
        tfPassword.isSecureTextEntry = !btnViewPass.isSelected
    }
    
    @IBAction func onLogin(_ sender: Any) {
        if validateFields() {
            presentor?.interactor?.callApi(email: tfEmail.text!, password: tfPassword.text!)
        }
        
    }
    
    @IBAction func onnForgotPass(_ sender: Any) {
        
    }

    @IBAction func onnSignup(_ sender: Any) {
       
    }
    
    func setupUI() {
        DispatchQueue.main.async {
            self.btnLogin.applyVerticalGradient(colours: [.AppStartGradient, .AppEndGradient], corners: [.bottomRight, .bottomLeft], radius: self.btnLogin.frame.size.height / 2)
        }
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.hide()
        self.vuMain.slightRound(radius: 25)
        self.btnLogin.addDropShadow()
        self.vuMain.addDropShadow()
        vuEmail.halfRound()
        vuEmail.setBorder()
        vuEmail.addDropShadow()
        vuPassword.halfRound()
        vuPassword.setBorder()
        vuPassword.addDropShadow()
        
        tfEmail.text = "test@gmail.com"
        tfPassword.text = "testtest"
    }
    
    func validateFields() -> Bool {
        if let err = Validator.validateRegistLogin(textFields: [tfEmail, tfPassword], vc: "LoginView")?.localizedDescription {
                self.view.makeToast(err, duration: 1.0, position: .center)
                return false
        } else {
            return true
        }
    }
}

extension LoginView:PresenterToViewLoginProtocol{
    
    func loginApiSuccess(data: LoginModel) {
        SwiftLoader.hide()
        presentor?.router?.pushToHome(navigationConroller: navigationController!)
    }
    
    func loginApiError(errMsg: String) {
        SwiftLoader.hide()
        let alert = UIAlertController(title: "Alert", message: errMsg.debugDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
