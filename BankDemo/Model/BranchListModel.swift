//
//  BranchListModel.swift
//  BankDemo
//
//  Created by hb on 18/09/17.
//  Copyright © 2017 hb. All rights reserved.
//

import UIKit

protocol BranchListModelDelegate {
    // protocol definition goes here
    func SuccessResponse(json: JSON)
    func FailResponse(message: String)
}


class BranchListModel: NSObject {

    var strSelectedBankName = ""
    
    static var sharedInstance : BranchListModel? = nil
    var delegate: BranchListModelDelegate? = nil
    
    
    class func shareInstance() -> BranchListModel {
        if sharedInstance == nil {
            sharedInstance = BranchListModel()
        }
        return sharedInstance!
    }
    
    func getRequest(strURL : String, Delegate delegateController: BranchListModelDelegate)
    {
        
        self.delegate = delegateController
        var strFinalURL = strURL.appending("/\(BranchListModel.shareInstance().strSelectedBankName)")
        strFinalURL = strFinalURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        APIService.requestURL(strFinalURL, methodType: .get, parameters: [:], isShowLoader: .Default, loadingText: "Loading", success: { (JSONResponse) in
            
            self.delegate?.SuccessResponse(json: JSONResponse)
            
        }) { (error) in
            
            debugPrint(error.localizedDescription)
            self.delegate?.FailResponse(message: error.localizedDescription)
            
        }
        
        
    }
    
}
