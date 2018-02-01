//
//  Global Method.swift
//  BankDemo
//
//  Created by hb on 11/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit
import AVFoundation

enum Status: String {
    case success = "success"
    case fail = "fail"
    case error = "error"
}

enum SearchType: String {
    case BEGINSWITH = "BEGINSWITH[c]"
    case CONTAINS = "CONTAINS[c]"
    case ENDSWITH = "ENDSWITH[c]"
    case LIKE = "LIKE[c]"
    case MATCHES = "MATCHES[c]"
}

enum isFrom_BankDetail: Int {

    case BranchList     = 0
    case IFSCCode       = 1
    case MICRCode       = 2
    case BranchName     = 3
    case Location       = 4
    case District       = 5
    case State          = 6
}


func setRootViewController(Controller_Identifier identifier : String )
{
    if !identifier.isEmpty
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let objVC = storyboard.instantiateViewController(withIdentifier: identifier) as? UIViewController
        {
            objVC.appDelegate.window?.rootViewController = objVC
            objVC.appDelegate.window?.makeKeyAndVisible()
        }
    }else{
        debugPrint("no found controller identifer..!!")
    }
}


extension UIViewController {
    var appDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}


extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

struct APIName {
    
    /* API Base URL */
    static let BaseURL = "https://api.techm.co.in/api/"
    
    /* Get Bank List API, Request Type:- GET, Response Type:- JSON */
    static let BankLists = BaseURL + "listbanks"
    
    /* Get Branch List By Name API, Request Type:- GET, Response Type:- JSON */
    static let BranchList = BaseURL + "listbranches"
    
    /* Get Branch Detail By BankName and Branch Name API, Request Type:- GET, Response Type:- JSON */
    static let BranchDetail = BaseURL + "getbank"
    
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
        //use:- Bundle.main.releaseVersionNumber
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
