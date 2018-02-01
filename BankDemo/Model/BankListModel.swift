//
//  BankListModel.swift
//  BankDemo
//
//  Created by hb on 13/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

protocol BankListModelDelegate {
    // protocol definition goes here
    func SuccessResponse(json: JSON)
    func FailResponse(message: String)
}

class BankListModel: NSObject {
    
   
    static var sharedInstance : BankListModel? = nil
    var delegate: BankListModelDelegate? = nil

    
    class func shareInstance() -> BankListModel {
        if sharedInstance == nil {
            sharedInstance = BankListModel()
        }
        return sharedInstance!
    }
    
    func getRequest(strURL : String = "", Delegate delegateController: BankListModelDelegate)
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
