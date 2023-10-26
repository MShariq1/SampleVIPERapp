//
//  HomeINteractor.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-12.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol PresenterToInteractorHomeProtocol: AnyObject {
    var presenter:InteractorToPresenterHomeProtocol? {get set}
    func callApi()
}

class HomeInteractor: PresenterToInteractorHomeProtocol{
    
    var presenter: InteractorToPresenterHomeProtocol?
    
    
    func callApi() {
        SwiftLoader.show(animated: true)
        Alamofire.request(homeURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response { (response) in
            
            if let error = response.error {
                self.presenter?.homeApiError(errMsg: error.localizedDescription)
            } else {
                do {
                     let json = try JSON(data: response.data!)
                        let status = response.response?.statusCode
                        
                        if status == 200 {
                            var model = [HomeModel]()
                            for jsonData in json.arrayValue {
                                let university = HomeModel(data: jsonData.rawValue as! [String : Any])
                                model.append(university)
                            }
                            self.presenter?.homeApiSuccess(data: model)
                        } else {
                            if let errorMessage = json.arrayValue.first?["error"] as? String {
                                self.presenter?.homeApiError(errMsg: errorMessage)
                            }
                        }
                   
                    
                } catch let error {
                    self.presenter?.homeApiError(errMsg: error.localizedDescription)
                }
            }
        }
    }
    
    
}
