//
//  AlertViewController.swift
//  BankDemo
//
//  Created by hb on 18/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

class AlertViewController: NSObject {

    
    
    class func showAlertView(Title strTitle:String, Message strMessage:String, ButtonTitle btnTitle:String, CurrentViewController viewController:UIViewController, completionHandler:@escaping (_ action: UIAlertAction) -> () )
    {
        // create the alert
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        
        /* change BGColor and set cornor radius of default alert
        (((alertController.view!.subviews[0] ).subviews[0]) ).backgroundColor = UIColor.red
        (((alertController.view!.subviews[0] ).subviews[0]) ).layer.cornerRadius = 5.0
        (((alertController.view!.subviews[0] ).subviews[0]) ).layer.masksToBounds = true
        */
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: btnTitle, style: UIAlertActionStyle.default, handler: { action in
           
            completionHandler(action)
        }))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func showAlertViewWithConfirmation(Title strTitle:String, Message strMessage:String, ButtonPositive btnTitle1:String, ButtonCancel btnTitle2:String, CurrentViewController viewController:UIViewController, completionHandler: @escaping (_ action: UIAlertAction) -> () )
    {
        // create the alert
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: btnTitle1, style: UIAlertActionStyle.default, handler: { action in
            
            debugPrint(action.hashValue)
            debugPrint(action.title ?? "")
            completionHandler(action)
        }))
        alert.addAction(UIAlertAction(title: btnTitle2, style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithTextField(Title strTitle:String, Message strMessage:String, TextPlaceholder placeholder:String, ButtonPositive btnTitle1:String, ButtonCancel btnTitle2:String, CurrentViewController viewController:UIViewController, completionHandler: @escaping (_ action: UIAlertAction) -> () )
    {
        let alertController = UIAlertController(title: strTitle, message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Search", style: .default, handler: {
            action -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            debugPrint(firstTextField.text ?? "")
            //let secondTextField = alertController.textFields![1] as UITextField
            completionHandler(action)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            completionHandler(action)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = placeholder
        }
//        alertController.addTextField { (textField : UITextField!) -> Void in
//            textField.placeholder = "Enter Second Name"
//        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}


