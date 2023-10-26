//
//  Enums.swift
//  Titanio
//
//  Created by NST on 21/03/2022.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardId
        guard let scene = instance.instantiateViewController(withIdentifier: storyboardID) as? T else {
            fatalError("ViewController with identifier \(storyboardID), not found in \(self.rawValue) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        return scene
    }
    
    func initialViewController() -> UIViewController? {
        return instance.instantiateInitialViewController()
    }
}

enum APIEnvironmentType {
    case live
    case dev
    case local
}

enum FontType: String {
    
//    case light = "Poppins-Light"
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semiBold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}

enum DateFormat: String {
    
    case date = "yyyy-MM-dd"
    case time = "HH:mm:ss"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case ddMMMyyyy = "dd MMM, yyyy"
    case caDateTime = "dd MMM, yyyy   HH:mm"
    case caDateParam = "MM/dd/yyyy"
    case clDateOnly = "MMMM dd, yyyy"
}

public enum fontFamily {
    case regular
    case bold
    case extraBold
    case medium
}

