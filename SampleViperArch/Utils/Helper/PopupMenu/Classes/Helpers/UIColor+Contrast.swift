//
//  UIColor+Contrast.swift
//  PopMenu
//
//  Created by Cali Castle on 4/14/18.
//  Copyright © 2018 PopMenu. All rights reserved.
//

import UIKit

extension UIColor {
    
    /// Get color rgba components in order.
    func rgba() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let components = self.cgColor.components
        let numberOfComponents = self.cgColor.numberOfComponents
        
        switch numberOfComponents {
        case 4:
            return (components![0], components![1], components![2], components![3])
        case 2:
            return (components![0], components![0], components![0], components![1])
        default:
            // FIXME: Fallback to black
            return (0, 0, 0, 1)
        }
    }
    
    /// Check the black or white contrast on given color.
    func blackOrWhiteContrastingColor() -> Color {
        let rgbaT = rgba()
        let value = 1 - ((0.299 * rgbaT.r) + (0.587 * rgbaT.g) + (0.114 * rgbaT.b));
        return value < 0.5 ? Color.black : Color.white
    }
    
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    enum AppTheme {
        
        case appDarkGray
        case appYellow
        case appGreen
        case appAccent
        case appDarkGrayAlpha
        case appBlue
        case appBlueAlpha
        
        func color() -> UIColor {
            switch self {
            case .appDarkGray:
                if #available(iOS 11.0, *) {
                    return UIColor(named: "AppDarkGray")!
                }
                return .darkGray
            case .appYellow:
                if #available(iOS 11.0, *) {
                    return UIColor(named: "PrivateConnection")!
                }
                return .yellow
                
            case .appGreen:
                return UIColor(named: "AppGreenAlpha")!
            
            case .appDarkGrayAlpha:
                return UIColor(named: "AppDarkGrayAlpha")!
            
            case .appAccent:
                return UIColor(named: "AppAccent")!
            
            case .appBlue:
                return UIColor(named: "AppBlue")!
           
            case .appBlueAlpha:
                return UIColor(named: "AppBlueAlpha")!
            }
        }
        
    }
}
