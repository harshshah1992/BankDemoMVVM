//
//  APIClient.swift
//  BankDemo
//
//  Created by harsh on 01/02/18.
//  Copyright © 2018 hb. All rights reserved.
//

import UIKit
import Alamofire


class APIClient: NSObject {
    
    var spinner = UIActivityIndicatorView()
    
    
    func fetchBankList(completion:@escaping(JSON?) -> Void){
            requestURL(APIName.BankLists, success: { (result) in
                completion(result)
            }, failure: { (error) in
                completion(nil)
            })
    }
    
    
    private func requestURL(_ strURL: String, methodType: HTTPMethod = HTTPMethod.get, parameters: Parameters = [:], isShowLoader: isShowLoader = .Default, loadingText: String = DefaultValue.LoaderText.rawValue,  success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
            
            switch isShowLoader {
            case .Show:
                spinner = showLoader(loadingText: loadingText)
                
            case .Hide:
                debugPrint("not show loader..")
                
            default:
                spinner = showLoader(loadingText: DefaultValue.LoaderText.rawValue)
            }
            
            if parameters.count > 0 && methodType == .post && !strURL.isEmpty
            {
                callPostAPI(strURL: strURL, parameters: parameters, success: success, failure: failure)
                
                
            }else{
                
                callGetAPI(strURL: strURL, parameters: parameters, success: success, failure: failure)
                
            }
            
        } else {
            print("No! internet is not available.")
            if let topController = UIApplication.shared.keyWindow!.rootViewController {
                AlertViewController.showAlertView(Title: "Network Error", Message: "Interner not available", ButtonTitle: "OK", CurrentViewController: topController, completionHandler: { (alertAction) in
                    
                })
            }
            
        }
        
    }
    
    func showLoader(loadingText: String) -> UIActivityIndicatorView {
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        view.tag = 10001
        
        //Customize as per your need
        
        let vwCenter = UIView()
        vwCenter.center = view.center
        vwCenter.frame = CGRect(x: view.frame.size.width / 2 - 75.0, y: view.frame.size.height / 2 - 75.0, width: 150.0, height: 150.0)
        vwCenter.backgroundColor = UIColor.lightGray
        vwCenter.layer.cornerRadius = 10.0
        vwCenter.clipsToBounds = true
        view.addSubview(vwCenter)
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: vwCenter.frame.size.width/2 - 20.0, y: 10.0, width: 40, height:40))
        spinner.backgroundColor = UIColor.clear
        spinner.hidesWhenStopped = true
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        vwCenter.addSubview(spinner)
        spinner.startAnimating()
        
        let lblText = UILabel(frame: CGRect(x: 5.0, y: spinner.frame.origin.y + spinner.frame.size.height + 10.0, width: vwCenter.frame.size.width - 10.0, height: 25.0))
        lblText.text = loadingText
        lblText.textColor = UIColor.black
        lblText.backgroundColor = UIColor.clear
        lblText.numberOfLines = 1
        lblText.textAlignment = .center
        vwCenter.addSubview(lblText)
        
        //update loaderCenter View frame after set loading Text
        vwCenter.frame = CGRect(x: vwCenter.frame.origin.x, y: vwCenter.frame.origin.y, width: vwCenter.frame.size.width, height: lblText.frame.size.height + lblText.frame.origin.y + 5.0)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        AppDelegate.shareAppdelegate().window?.addSubview(view)
        
        return spinner
    }
    
    func callPostAPI(strURL: String, parameters: Parameters, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void) {
        
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
                self.spinner.dismissLoader()
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
                self.spinner.dismissLoader()
            }
        }
    }
    
    func callGetAPI(strURL: String, parameters: Parameters, success: @escaping (JSON) -> Void, failure: @escaping (Error) -> Void) {
        
        Alamofire.request(strURL, parameters: parameters).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
                self.spinner.dismissLoader()
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
                self.spinner.dismissLoader()
            }
        }
    }
}
