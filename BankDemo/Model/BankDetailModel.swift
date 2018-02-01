//
//  BankDetailModel.swift
//  BankDemo
//
//  Created by hb on 18/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

protocol BankDetailModelDelegate {
    // protocol definition goes here
    func SuccessResponse(json: JSON)
    func FailResponse(message: String)
}



class BankDetailModel: NSObject {

    var strSelectedBranchName = ""
    var isFrom = 0
    
    static var sharedInstance : BankDetailModel? = nil
    var delegate: BankDetailModelDelegate? = nil
    
    
    class func shareInstance() -> BankDetailModel {
        if sharedInstance == nil {
            sharedInstance = BankDetailModel()
        }
        return sharedInstance!
    }
    
    func getRequest(strURL : String, Delegate delegateController: BankDetailModelDelegate)
    {
        
        self.delegate = delegateController
        
        APIService.requestURL(strURL, methodType: .get, parameters: [:], isShowLoader: .Default, loadingText: "Loading", success: { (JSONResponse) in
            
            self.delegate?.SuccessResponse(json: JSONResponse)
            
            
        }) { (error) in
            
            debugPrint(error.localizedDescription)
            self.delegate?.FailResponse(message: error.localizedDescription)
            
        }
        
        
    }
    
}
