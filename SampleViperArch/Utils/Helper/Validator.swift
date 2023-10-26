//
//  Validator.swift
//  ShifaamPatient
//
//  Created by Usama Naseer on 12/10/19.
//  Copyright © 2019 Kamran Anjum. All rights reserved.
//

import Foundation
import UIKit

protocol FieldErrorProtocol {
    var localizedTitle: String { get }
    var localizedDescription: String { get }
    var textField:UITextField { get }
}

/**
 Field Error is used in TextField validations. The error will contain the textfield which caused the error.
 */
struct FieldError: FieldErrorProtocol {
    var localizedTitle: String
    var localizedDescription: String
    var textField: UITextField
    
    init(localizedTitle: String? = "Error", localizedDescription: String, textField:UITextField) {
        self.localizedTitle = localizedTitle!
        self.localizedDescription = localizedDescription
        self.textField=textField
    }
}

class Validator: NSObject {
    /**
     Validates Empty Text fields
     
     -parameter textFields: Array of textfields to validate
     -returns: A field error if any text field is empty.
     */
    class func validateEmptyTextFields(textFields:[UITextField])->FieldError?{
        for textField in textFields{
            if(textField.text!.isEmpty){
                if (textField.placeholder ?? "").contains("phone") || (textField.placeholder ?? "").contains("Phone") {
                   return FieldError(localizedDescription: "\(textField.placeholder ?? "This field") is Required", textField: textField)
                }else{
                    return FieldError(localizedDescription: "\(textField.placeholder ?? "This field") is Required", textField: textField)
                }
            } else if (textField.placeholder ?? "").contains("email") || (textField.placeholder ?? "").contains("Email") {
                if !textField.text!.isValidEmail() {
                    return FieldError(localizedDescription: "Invalid Email Address", textField: textField)
                }
            }
        }
        return nil
    }
    
    
    class func validateRegistLogin(textFields:[UITextField], vc: String)->FieldError?{
        for textField in textFields{
            if(textField.text!.isEmpty){
                if vc == "RegisterationVC" {
                    return FieldError(localizedDescription: "\(textField.placeholder ?? "This field") is Required", textField: textField)
                }else{
                    return FieldError(localizedDescription: "\(textField.placeholder ?? "This field") is Required", textField: textField)
                }
            } else if (textField.placeholder ?? "").contains("email") || (textField.placeholder ?? "").contains("Email") {
                if !textField.text!.isValidEmail() {
                    return FieldError(localizedDescription: "Please Enter a Valid Email", textField: textField)
                }
            }
        }
        return nil
    }
    class func validatetextView(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                // this will be reached if the text is nil (unlikely)
                // or if the text only contains white spaces
                // or no text at all
                return false
        }
        return true
    }
    
    
    /**
     Validates Password text field, checks if character count is greater than 6
     
     -parameter textField: Textfield to validate
     -returns: A field error if any case is not satisfied
     */
    class func validatePasswordTextField(textField:UITextField)->FieldError?{
        if(textField.text!.count < 6){
            return FieldError(localizedDescription: "Password cannot be less then 6 characters", textField: textField)
        }
        return nil
        
    }
    
    /**
     Validates Email text field, checks if email is in the right format
     
     -parameter textFields: Textfield to validate
     -returns: A field error if email format is wrong
     */
    class func validateEmail(textField:UITextField)->FieldError?{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if (textField.text?.range(of: emailRegex, options: .regularExpression) == nil){
            return FieldError(localizedDescription: "Please Enter a Valid Email", textField: textField)
        }
        return nil
    }
    
    /**
     Validates Password and Confirm password Text fields
     
     -parameter textFields: Array of textfields to compare
     -returns: A field error if text does not match.
     */
    class func comparePasswordTextFields(textFields:[UITextField])->FieldError?{
        if(textFields.first?.text != textFields.last?.text){
            return FieldError(localizedDescription: "Passwords do not match", textField: textFields.last!)
        }
        return nil
    }
    
    
}
extension UITextField {
    func addRequiredAsterisk()  {
          let asterisk =  UILabel()
          let string = ("*" as NSString).range(of: "*")
        asterisk.frame =  CGRect.init(x: self.frame.size.width - 20, y: self.frame.size.height / 3, width: 20, height: 20)
          let redAst = NSMutableAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
          redAst.addAttribute(NSAttributedString.Key.font,value:UIFont.systemFont(ofSize: 32, weight: .regular), range: string)

          asterisk.attributedText = redAst
          self.addSubview(asterisk)
      }
}
