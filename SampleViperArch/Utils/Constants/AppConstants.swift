//
//  AppConstants.swift
//
//  Created by Apple on 19/11/2019.
//  Copyright © 2019 Syed Ahmed Fraz Zaki. All rights reserved.
//

import UIKit
import Alamofire


class AppConstants {
    
    static var shared = AppConstants()
    static var environment: APIEnvironmentType = .dev
    
    static var apiURL: String {
        get {
            switch environment {
            case .dev:  return "http://universities.hipolabs.com/"
            case .local:  return "http://universities.hipolabs.com/"
            case .live: return "http://universities.hipolabs.com/"
            }
        }
    }
    
    static var socketURL: String {
        get {
            switch environment {
            case .dev:  return ""
            case .local:  return ""
            case .live: return ""
            }
        }
    }
    

    class func geFileurlFromStorage(fileName: String) -> URL? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        if let dirPath = paths.first {
            return URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
        }
        return nil
    }
    
    class func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
    class func saveServerVideoInStorage(fileUrl: String, fileName: String, onCompletion: @escaping ((URL?) -> Void)) {

        

            Alamofire.request(fileUrl).downloadProgress(closure : { (progress) in

              print(progress.fractionCompleted)

              print(Float(progress.fractionCompleted))

              }).responseData{ (response) in

                 print(response)

                 print(response.result.value!)

                 print(response.result.description)

                  if let data = response.result.value {


     

                      let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

                      let videoURL = documentsURL.appendingPathComponent(fileName)

                      do {

                          try data.write(to: videoURL)

                        onCompletion(videoURL)

                          } catch {

                          print("Something went wrong!")

                            onCompletion(nil)

                      }

                  }

              }

        }
    
    
}




